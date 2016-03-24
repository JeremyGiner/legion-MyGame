package mygame.game.ability;

import collider.CollisionCheckerPost;
import legion.ability.IAbility;
import math.Limit;
import mygame.game.entity.WorldMap;
import mygame.game.entity.Unit;
import mygame.game.ability.Mobility;
import mygame.game.ability.Volume;
import mygame.game.utils.PathFinderFlowField in Pathfinder;
import mygame.game.tile.Tile;
import mygame.game.tile.*;
import space.AlignedAxisBox;
import space.Vector3;
import space.Vector2i;
import utils.IntTool;
import utils.ListTool;

/**
 * Ability for a unit to walk a path toward a valid position using his Mobility ability
 * @author GINER Jérémy
 */

class Guidance extends UnitAbility {
	
	var _oMobility :Mobility;
	var _oVolume :Volume;
	var _oPlan :PositionPlan;
	
	var _oPathfinder :Pathfinder;
	var _oGoal :Vector2i;	// End of the path
	
	// Calculable
	var _oGoalTile :Tile;
	
//______________________________________________________________________________
//	Constructor

	public function new( oUnit :Unit ) :Void {
		super( oUnit );
		_oMobility = oUnit.ability_get( Mobility );
		if ( _oMobility == null )
			throw 'Guidance require mobility';
			
		_oVolume = oUnit.ability_get( Volume );
		_oPlan = oUnit.ability_get( PositionPlan );
		
		_oPathfinder = null;
		
		goal_set( null );
	}

//______________________________________________________________________________
//	Accessor

	public function goal_get() { return _oGoal; }
	
	public function mobility_get() { return _oMobility; }
	
	public function pathfinder_get() { return _oPathfinder; }

//______________________________________________________________________________
//	Modifier
	
	public function goal_set( oDestination :Vector2i ) {
		
		// Case : explicite reset
		if ( oDestination == null ) {
			_oGoal = null;
			_oGoalTile = null;
			return;
		}
		
		var oTileDestination = _oMobility.position_get().map_get().tile_get_byUnitMetric( 
			oDestination.x,
			oDestination.y
		);
		
		// Check destination tile validity
		if ( 
			!_oPlan.tile_check( oTileDestination )
		) {
			_oGoal = null;
			_oGoalTile = null;
			return;
		}
		
		
		// Update pathfinder
		// Get starting and ending tiles
		var lDestination = new List<Tile>();
		lDestination.add( oTileDestination );
		
		var lPosition = new List<Tile>();
		if( _oVolume == null )
			lPosition.push( _oMobility.position_get().tile_get() );
		else {
			lPosition = _oVolume.tileList_get();
			
			// For the quick fix
			lPosition = ListTool.merged_get( lPosition, _oVolume.tileListProject_get( oDestination.x, oDestination.y ) );
		}
		// Lauch path process
		_oPathfinder = new Pathfinder( 
			_oMobility.position_get().map_get(),
			lPosition, 
			lDestination,
			_oPlan.tile_check
		);
		if ( 
			_oPathfinder.success_check()
		) {
			_oGoal = oDestination.clone();
			if( _oVolume != null ) {
				_oGoal = Mobility.positionCorrection( _oMobility, _oGoal );
				
				// Settup tile occupied by the end position volume as end tile
				for( oTile in _oVolume.tileListProject_get( _oGoal.x, _oGoal.y ) )
					_oPathfinder.refTile_set( oTile, oTile );
			}
			
			_oGoalTile = _oMobility.position_get().map_get().tile_get_byUnitMetric( 
				_oGoal.x,
				_oGoal.y
			);
		} else {
			trace( '[ERROR]:Guidance:no path found.' );
			_oGoal = null;
			_oGoalTile = null;
		}
	}
	

//______________________________________________________________________________
//	Utils


	
//______________________________________________________________________________
//	Process

	public function process() :Void {
		
		//
		if ( _oGoal != null && _oGoal.equal(_oMobility.position_get()) )
			_oGoal = null;
		
		// Check if a goal is set
		if( _oGoal == null ) {
			_oMobility.force_set( 'Guidance', 0, 0, true ); 
			return;
		}
		// else
		
		// Set mobility direction
		var oVector = _vector_get();
		_oMobility.force_set( 'Guidance', oVector.x, oVector.y, true );
	}
	
	
//______________________________________________________________________________
//	Other

	public function _vector_get() :Vector2i {
		/*
		 * Smoothing algorithm
		 * -get next direction
		 * 	get position
		 *  get tile from position
		 * 	get ref tile from position tile
		 * 	get ref tile of ref tile
		 * 	'triangulate' to get direction from tile ref ref center, position, tile ref 
		 */
		
		// WARNING: position, refTile.center and refrefTile.center must be different
		
		// Get target tile
		var oTileOrigin = null;
		var oTileTargeted = null;
		
		if ( _oVolume == null ) {
		// Case : No volume
			var oTilePosition = _oMobility.position_get().tile_get();
			oTileTargeted = _oPathfinder.refTile_get( oTilePosition );
			
			// Check if end tile
			if( oTileTargeted == oTilePosition )
				return new Vector2i(
					_oGoal.x - _oMobility.position_get().x, 
					_oGoal.y - _oMobility.position_get().y
				);
		} else {
		// Case : Volume
			// Find the tile in which volume is on which have the hightest heat
			var lTile = _oVolume.tileList_get();
			
			// Check if end tile
			var b = true;
			for ( oTile in lTile )
				if ( oTile != _oPathfinder.refTile_get( oTile ) ) {
					b = false;
					break;
				}
			
			if( b )
				return new Vector2i(
					_oGoal.x - _oMobility.position_get().x, 
					_oGoal.y - _oMobility.position_get().y
				);
			
			// Case : Unit only on a unique tile
		// TODO : make straight shortcut
			switch( lTile.length ) {
			case 1 : 
				oTileTargeted = _oPathfinder.refTile_get( lTile.first() );

			case 2,4 :
				// Check if 2 tile are from the same road
				if ( 
					_pathAssociated_check( _oPathfinder, lTile )
				) {
					// Case same road
						// set targeted tile with the tile with the highest heat
						var heatBest = -1;
						var heatCurrent = null;
						for ( oTile in lTile ) {
							heatCurrent = _oPathfinder.heat_get_byTile( oTile );
							if ( heatCurrent > heatBest ) {
								heatBest = heatCurrent;
								oTileOrigin = oTile;
							}
						}
						oTileTargeted = _oPathfinder.refTile_get( oTileOrigin );
				} else {
					// Case different road
						// set targeted tile with the tile with the least heat
						var heatBest = 100000;
						var heatCurrent = null;
						for ( oTile in lTile ) {
							heatCurrent = _oPathfinder.heat_get_byTile( oTile );
							if ( heatCurrent < heatBest ) {
								heatBest = heatCurrent;
								oTileTargeted = oTile;
							}
						}
						// reminder : oTileOrigin = null;
						
				}
			default :
				throw('what?! abnormal volume');
			}
		}
		
		// Check integrity
		if ( oTileTargeted == null ) {
			throw('[ERROR]:pathfinder : wandering unit');
		}
		
		// Case : End of path
		/*if( oTileTargeted == _oGoalTile )
			return new Vector3(
				_oGoal.x - _oMobility.position_get().x, 
				_oGoal.y - _oMobility.position_get().y
			);*/
		
		// Get ref ref tile
		var oTileTargetedRef = _oPathfinder.refTile_get( oTileTargeted );
		
		// Get vector between position and center of the reference tile
		var v1 = new Vector2i( 
			(oTileTargeted.x_get() * 10000 + 5000) -_oMobility.position_get().x, 
			(oTileTargeted.y_get() * 10000 + 5000) -_oMobility.position_get().y
		);
		
		// Get vector between position and center of the refref tile
		var v2 :Vector2i = null;
		if ( 
			oTileTargeted == oTileTargetedRef	// Only end of path tile have themself as ref
		) {
			// Case : end of path
			// -> use goal for v2
			v2 = new Vector2i( 
				_oGoal.x - _oMobility.position_get().x, 
				_oGoal.y - _oMobility.position_get().y 
			);
		} else {
			// Case : NOT end of path
			// -> use ref tile center for v2
			v2 = new Vector2i( 
				(oTileTargetedRef.x_get() * 10000 + 5000) - _oMobility.position_get().x, 
				(oTileTargetedRef.y_get() * 10000 + 5000) - _oMobility.position_get().y
			);
		}
		
		// Project vector tileRef<->position (v1) on position<->refref (v2)
		//var v3 = v1.clone().project( v2 );
		
		var fV2Length = v2.length_get();
		var fProjMult = v1.dotProduct( v2 ) / (fV2Length * fV2Length);
		
		var v3 = ( fProjMult > 0 ) ? 
			v2.clone().mult( fProjMult ) :
			v2.clone();	// Case > 90° => fall back on v2
		
		// Change v3 context to map coordonate
		v3.add(
			_oMobility.position_get().x,
			_oMobility.position_get().y
		);
		
		// Clamp entity into target tile
		if ( 
			// Check if end tile ( Only end of path tile have themself as ref )
			oTileOrigin != oTileTargeted
		) {
			// Clamp
			if ( _oVolume == null ) {
				// Clamp v3 into ref tile
				v3.set(
					IntTool.max( IntTool.min( v3.x, oTileTargeted.x_get()*10000+9999 ), oTileTargeted.x_get()*10000 ),
					IntTool.max( IntTool.min( v3.y, oTileTargeted.y_get()*10000+9999 ), oTileTargeted.y_get()*10000 )
				);
			} else {
				// Clamp v3 into ref tile minus volume size
				var fSize = _oVolume.size_get();
				v3.set(
					IntTool.max( IntTool.min( v3.x, oTileTargeted.x_get()*10000+9999-fSize ), oTileTargeted.x_get()*10000+fSize ),
					IntTool.max( IntTool.min( v3.y, oTileTargeted.y_get()*10000+9999-fSize ), oTileTargeted.y_get()*10000+fSize )
				);
			}
		}
		
		// Transform v3 to be relatif to position
		v3.add(
			-_oMobility.position_get().x,
			-_oMobility.position_get().y
		);
		
		//test (TODO:remove)
		if( !Math.isFinite(v3.x) || !Math.isFinite(v3.y) )
			throw('[ERROR]:Guidance:invalide vector:' + v3);
		
		
		return v3;
	}
	
	/**
	 * check if the tiles are part of the same road
	 * @return true if they are associated
	 */
	function _pathAssociated_check( oPathfinder :Pathfinder, lTile :List<Tile> ) {
		var i = 0;
		// Count number of link between tiles
		for ( oTile in lTile ) {
			
			// Get ref tile
			var oTileRef = oPathfinder.refTile_get( oTile );
			
			// Look for link
			for ( oTileTmp in lTile ) {
				if ( oTileTmp == oTileRef )
					i++;
				if ( oPathfinder.refTile_get( oTileTmp ) == oTileRef )
					i++;
			}
		}
		
		return i >= (lTile.length - 1);
	}
	
//______________________________________________________________________________
//	Disposer
	
	/*override public function dispose() {
		super.dispose();
		
	}*/


}