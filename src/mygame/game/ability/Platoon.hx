package mygame.game.ability;

import collider.CollisionCheckerPostInt;
import legion.ability.IAbility;
import legion.entity.Entity;
import mygame.game.entity.Unit;
import mygame.game.misc.weapon.EDamageType;
import mygame.game.tile.Tile;
import mygame.game.utils.SubUnitFactory;
import space.AlignedAxisBox2i;
import space.AlignedAxisBoxAlti;
import space.Vector2i;
import space.Vector3;
import trigger.*;

import mygame.game.entity.SubUnit;

class Platoon extends EntityAbility {
	
	var _aSubUnit :Array<Unit>;
	var _iUnitQ :Int;
	
	var _iVolume :Int;
	
	var _fDirection :Float;
	
	// Calculable
	var _iPitch :Int;
	
//______________________________________________________________________________
//	Constructor

	public function new( 
		oCommander :Unit
	) {
		super( oCommander );
		
		_iUnitQ = 20;	// ]0;++]
		_iVolume = 8000;
		_fDirection = Math.PI / 4;
		
		// create children
		var oPosition = oCommander.ability_get(Position);
		var oPlayer = oCommander.ability_get(Loyalty).owner_get();
		
		_aSubUnit = [ oCommander ];
		var sClassName = Type.getClassName( Type.getClass( entity_get() ) );
		for ( i in 0..._iUnitQ-1 ) {
			_aSubUnit.push( 
				SubUnitFactory.STcreate(
					sClassName,
					cast oCommander.game_get(),
					oPlayer,
					offset_get( oPosition, i, _fDirection ),
					this
				) 
			);
		}
		
		// Add into the game
		for ( oSubUnit in _aSubUnit ) {
			// Skip commander : assume he is already assign to the game
			if ( oCommander == oSubUnit )
				continue;
			
			// Add
			entity_get().game_get().entity_add( oSubUnit );
		}
	}

//______________________________________________________________________________
//	Accessor

	override public function entity_get() {
		return commander_get();
	}

	public function commander_get() {
		return subUnit_get()[0];
	}

	public function subUnit_get() {
		// refresh
		// TODO : on dispose?
		var a = _aSubUnit.copy();
		for ( o in a )
			if ( o.dispose_check() )
				_aSubUnit.remove( o );
		
		return _aSubUnit;
	}
	
	public function offset_get( oPosition :Vector2i, iKey :Int, fAngle :Float ) {
		if ( oPosition == null )
			return null;
		
		fAngle += Math.PI/2;
		
		var iPitch = Math.ceil( Math.sqrt(_iUnitQ) );
		var fOffsetCenter = Math.floor(_iVolume / 2);
		var fOffsetX = ( iKey / _iUnitQ )* _iVolume - fOffsetCenter;//(iKey % iPitch) * positionPading_get() - fOffsetCenter;
		var fOffsetY = 0;//Math.floor( iKey / iPitch ) * positionPading_get() - fOffsetCenter;
		var fCos = Math.cos(fAngle);
		var fSin = Math.sin(fAngle);
		
		return new Vector2i( 
			Math.round( oPosition.x + fOffsetX * fCos - fOffsetY * fSin ), 
			Math.round( oPosition.y + fOffsetY * fCos + fOffsetX * fSin )
		);
	}
	/**
	 * @return space between each unit (must be inferior to something)
	 */
	public function positionPading_get() {
		return Math.floor( _iVolume / (Math.ceil( Math.sqrt(_iUnitQ) )-1) );
	}
	
	public function halfSize_get() {
		return Math.ceil( _iVolume / 2 );
	}
	
	public function unitQuantityMax_get() {
		return _iUnitQ;
	}
	
	/**
	 * Retreive the list of tile occupied by this volume 
	 * if it was at a given position
	 */
	public function tileListProject_get( x :Int, y :Int ) :List<Tile> {
		
		var iHalfSize = _iVolume / 2;
		var loTile = untyped commander_get().game_get().map_get().tileList_get_byArea( 
			Math.floor( (x-iHalfSize)/10000 ), 
			Math.floor( (x+iHalfSize)/10000 ),
			Math.floor( (y-iHalfSize)/10000 ), 
			Math.floor( (y+iHalfSize)/10000 )
		);
		
		return loTile;
	}
	
	public function positionCorrection( oPoint :Vector2i ) {
		
		var oPlan = commander_get().ability_get(PositionPlan);
		
		if ( oPlan == null )
			return oPoint;
		
		// Get map
		var oMap = commander_get().ability_get(Position).map_get();
		
		// Get target and neightbor Tile
		var lTile = tileListProject_get( oPoint.x, oPoint.y );
		
		// Clamp on target tile
		var oResult = oPoint.clone();
		
		var _iHalfSize = halfSize_get();
		var oUnitGeometry = new AlignedAxisBox2i( 
			_iHalfSize, 
			_iHalfSize, 
			oPoint 
		);
		
		var oTileGeometry :AlignedAxisBoxAlti;
		
		for ( oTile in lTile ) {
			// Filter walkable and non colling tile
			if ( oPlan.validate( oTile ) ) 
				continue;
			
			// Build up tile geometry
			oTileGeometry = Tile.tileGeometry_get( oTile );
			
			// Filter non colling tile
			if ( 
				!CollisionCheckerPostInt.check( 
					oUnitGeometry,
					oTileGeometry
				)
			) 
				continue;
			
			//_____
			var iVolumeSize = _iHalfSize;
			var dx :Float = oPoint.x/10000 - (oTile.x_get()+0.5);
			var dy :Float = oPoint.y/10000 - (oTile.y_get()+0.5);
			if ( Math.abs(dx) > Math.abs(dy) )
				// Clamp on X axis
				oResult.x = ( dx > 0 ) ?
					oTileGeometry.right_get() + 1 + iVolumeSize : 
					oTileGeometry.left_get()-1 - iVolumeSize;
			else
				// Clamp on Y axis
				oResult.y = ( dy > 0 ) ?
					oTileGeometry.top_get() + 1 + iVolumeSize : 
					oTileGeometry.bottom_get()-1 - iVolumeSize;
		}
		return oResult;
		
		throw('abnormal case');
		return null;
	}
	
//______________________________________________________________________________
//	Modifier
	
	/**
	 * 
	 * @param	oDestination
	 */
	public function waypoint_set( oDestination :Vector2i, fAngle :Float ) {
		
		// TODO : check destination
		/*
		var oTileDestination = _oMobility.position_get().map_get().tile_get_byUnitMetric( 
			oDestination.x,
			oDestination.y
		);
		
		// Check destination tile validity
		if ( 
			!_oPlan.check( oTileDestination )
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
			_oPlan
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
		}*/
		
		var aUnit = subUnit_get();
		for ( i in 0...aUnit.length ) {
			
			var oGuidance = aUnit[i].ability_get(Guidance);
			
			if ( oGuidance == null )
				throw('Expected a guidance');
			
			var oOffset = offset_get( oDestination, i, fAngle );
			
			oGuidance.waypoint_set( oOffset );
		}
	}
	
	public function waypoint_add( oDestination :Vector2i, fAngle :Float ) {
		// TODO : check destination
		
		var aUnit = subUnit_get();
		for ( i in 0...aUnit.length ) {
			
			var oGuidance = aUnit[i].ability_get(Guidance);
			
			if ( oGuidance == null )
				throw('Expected a guidance');
			
			var oOffset = offset_get( oDestination, i, fAngle );
			
			oGuidance.waypoint_add( oOffset );
		}
	}
//______________________________________________________________________________
//	


}