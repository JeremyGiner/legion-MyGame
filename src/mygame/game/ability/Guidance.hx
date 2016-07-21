package mygame.game.ability;

import collider.CollisionCheckerPost;
import legion.ability.IAbility;
import legion.IBehaviour;
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
 * Ability for an entity to walk a path toward a valid position using his Mobility ability
 * @author GINER Jérémy
 */

class Guidance extends UnitAbility implements IBehaviour {
	
	var _oMobility :Mobility;
	var _oVolume :Volume;
	var _oPlan :PositionPlan;
	
	var _oPathfinder :Pathfinder;
	var _lWaypoint :List<Vector2i>;
	
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
		_lWaypoint = new List<Vector2i>();
	}

//______________________________________________________________________________
//	Accessor

	public function waypointList_get() { return _lWaypoint; }
	
	public function mobility_get() { return _oMobility; }
	
	public function pathfinder_get() { return _oPathfinder; }
	
	public function processName_get() { return 'guidance'; }
	
	public function positionCorrection( oPoint :Vector2i ) {
		
		// Case no PositionPlan
		if ( _oMobility.plan_get() == null )
			return oPoint;
		
		// Case platoon
		var oPlatoon = unit_get().ability_get(Platoon);
		if( oPlatoon != null )
			return oPlatoon.positionCorrection( oPoint );
		
		// Case no volume
		var oVolume = _oVolume;
		if ( oVolume == null ) {
			
			var oMap = _oMobility.position_get().map_get();
			var oTile = oMap.tile_get_byUnitMetric( oPoint.x, oPoint.y );
			if( _oMobility.plan_get().validate( oTile ) )
				return oPoint;
			
			return null;
		} else {
			// Case volume
			return oVolume.positionCorrection( oPoint );
		}
		
		throw('abnormal case');
		return null;
	}

//______________________________________________________________________________
//	Modifier
	
	public function waypoint_add( oDestination :Vector2i ) {
		_lWaypoint.add( oDestination.clone() );
		
		// If no other waypoint -> path immediately
		if ( _lWaypoint.length == 1 )
			_pathTo();
	}
	public function waypoint_set( oDestination :Vector2i ) {
		
		_lWaypoint = new List<Vector2i>();
		
		// Case : explicit reset
		if ( oDestination == null ) 
			return;
		
		// Apply change
		_lWaypoint.add( oDestination.clone() );
		_pathTo();
	}
	
//______________________________________________________________________________
//	Process

	public function process() :Void {
		
		// Reset if is on current destination
		if (
			_lWaypoint.length != 0 && 
			_lWaypoint.first().equal( _oMobility.position_get() ) 
		)
			_waypoint_discard();
		
		// Set mobility direction
		if( _oPathfinder != null ) {
			var oVector = _vector_get();
			_oMobility.force_set( 'Guidance', oVector.x, oVector.y, true );
		} else {
			_oMobility.force_set( 'Guidance', 0, 0, true );
		}
	}
	
	
//______________________________________________________________________________
//	Sub-routine
	
	function _waypoint_discard() {
		_lWaypoint.pop();
		_oPathfinder = null;
		_pathTo();
	}
	
	/**
	 * Process pathfinding for current destination ( after validating it )
	 * Must be called everytime _lWaypoint change his first element
	 */
	function _pathTo() {
		
		// Case : nothing to path
		if ( _lWaypoint.length == 0 ) 
			return;
		
		// Get some destination and his tile
		var oDestination = _lWaypoint.first();
		var oTileDestination = _oMobility.position_get().map_get().tile_get_byUnitMetric( 
			oDestination.x,
			oDestination.y
		);
		
		// Check destination tile validity
		if ( 
			!_oPlan.validate( oTileDestination )
		) {
			// Discard destination
			_waypoint_discard();
			trace('[WARNING]:guidance:invalid destination tile');
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
		
		// Lauch pathfinding process
		_oPathfinder = new Pathfinder( 
			_oMobility.position_get().map_get(),
			//lPosition, 
			lDestination,
			_oPlan
		);
		
		// Check pathfinder succcess
		for ( oTile in lPosition ) {
			if ( _oPathfinder.refTile_get( oTile ) == null ) {
				_waypoint_discard();
				trace( '[ERROR]:Guidance:no path found.' );
				return;
			}
		}
		
		// Volume fix
		if( _oVolume != null ) {
			
			//TODO : make it work with lDestination
			// Settup tile occupied by the end position volume as end tile
			for( oTile in _oVolume.tileListProject_get( oDestination.x, oDestination.y ) )
				_oPathfinder.refTile_set( oTile, oTile );
		}
	}

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
		
		var oDestination = _lWaypoint.first();
		
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
					oDestination.x - _oMobility.position_get().x, 
					oDestination.y - _oMobility.position_get().y
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
					oDestination.x - _oMobility.position_get().x, 
					oDestination.y - _oMobility.position_get().y
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
		/*if( oTileTargeted == oDestinationTile )
			return new Vector3(
				oDestination.x - _oMobility.position_get().x, 
				oDestination.y - _oMobility.position_get().y
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
				oDestination.x - _oMobility.position_get().x, 
				oDestination.y - _oMobility.position_get().y 
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


}