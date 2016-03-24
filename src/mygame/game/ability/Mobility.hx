package mygame.game.ability;

import collider.CollisionCheckerPriorInt;
import collider.CollisionCheckerPostInt;
import collider.CollisionEventPriorInt;
import haxe.ds.StringMap;
import haxe.ds.Vector;
import legion.ability.IAbility;
import mygame.game.entity.Unit;
import mygame.game.entity.WorldMap;
import mygame.game.tile.Tile;
import mygame.game.tile.*;
import space.AlignedAxisBox2i;
import space.AlignedAxisBoxAlti;
import space.IAlignedAxisBox;
import space.Vector2i;
import space.Vector3;
import space.AlignedAxisBox;
import utils.IntTool;

class Mobility extends UnitAbility {
	
	// Outside
	var _oPosition :Position;
	var _oPlan :PositionPlan;
	var _oVolume :Volume;
	
	// Inside
	//var _iType :Int;
	var _fSpeed :Float;	// Maximum speed
	var _oVelocity :Vector2i; // Next step relatif to current position
	
	var _moForce :StringMap<Force>;
	
	// Orientation
	var _fOrientation :Float; //radian
	var _fOrientationSpeed :Float;
	
	// Calculable
	var _oGoalTile :Tile;

//______________________________________________________________________________
//	Constructor

	public function new( oUnit :Unit, fSpeed :Float ) :Void {
		super( oUnit );
		_oPosition = oUnit.ability_get(Position);
		_oPlan = oUnit.ability_get(PositionPlan);
		_oVolume = oUnit.ability_get(Volume);
		if( _oPosition == null ) trace('[ERROR]:Mobility require Positione ability.');

		_fSpeed = fSpeed;	//TOOD : max TILESIZE?
		_oVelocity = new Vector2i(0,0); // Relative to position
		
		_fOrientation = 0;
		_fOrientationSpeed = 0.4;
		
		_moForce = new StringMap<Force>();
		
	}

//______________________________________________________________________________
//	Accessor

	public function position_get() { return _oPosition; }
	
	public function plan_get() { return _oPlan; }
	
	public function orientation_get() { return _fOrientation; }
	
//______________________________________________________________________________
//	Modifier

	public function speed_set( fSpeed :Float) {
		_fSpeed = fSpeed;
	}

	public function orientationSpeed_set( fOrientationSpeed :Float ) {
		_fOrientationSpeed = fOrientationSpeed;
	}

	public function force_set( sKey :String, fX :Int, fY :Int, bSpeedLimit :Bool = true ) {
		_moForce.set( sKey, cast { oVector: new Vector2i( fX, fY ), bLimit: bSpeedLimit } );
	}
	
	public function direction_set( oVector :Vector2i ) {
		var v = oVector.clone();
		v.length_set( _fSpeed );
		_oVelocity.set( v.x, v.y );
	}
	
	
	
//______________________________________________________________________________
//	Process

	public function move() :Void {
	
	// Get velocity
		_oVelocity.set( 0, 0 );
		for ( oForce in _moForce ) {
			var oVector = oForce.oVector.clone();
			
			// Speed limit
			if( oForce.bLimit && oVector.length_get() > _fSpeed )
				oVector.length_set( _fSpeed );
			
			// Add
			_oVelocity.add( oVector.x, oVector.y );
		}
		
	// Check direction
		if( _oVelocity.x == 0 && _oVelocity.y == 0 )
			return;
	
	// Update orientation
		var oVectorOrientation :Vector2i = null;
		if ( _moForce.get('Guidance') != null ) {
			oVectorOrientation = _moForce.get('Guidance').oVector.clone();
			_orientation_update( oVectorOrientation );
		}
	
	// Apply plan limit
		_collision_process();
		
	// Update position
		_position_set( _oVelocity.x + _oPosition.x, _oVelocity.y + _oPosition.y );
		//trace( _oPosition.x + ';' + _oPosition.y );
	}
	
//______________________________________________________________________________
//	Other

	// Clamp between [ 0; PI*2 ]
	function clampAngle(a :Float) {
		var b = a;
		while( b >= Math.PI*2 )
			b -= Math.PI*2;
		while( b < 0 )
			b += Math.PI*2;
			
		b %= Math.PI*2;
		return b;
	}
	
	
//______________________________________________________________________________
//	Sub-routine

	function _position_set( fPositionX :Int, fPositionY :Int ) {
		
		_oPosition.set( fPositionX, fPositionY );
	}

	function _orientation_update( oDirection :Vector2i ) {
		if ( oDirection == null )
			return;
		
		var fGoal =  oDirection.angleAxisXY();
		
		if ( fGoal == null )
			return;
		
		fGoal = clampAngle( fGoal );
		
		if( _fOrientation != fGoal ) {
			// Get delta
			var fDelta :Float = fGoal - _fOrientation; //delta ref unit orientation with a [+] rotation

			// Turn
			if( fDelta == 0 ) {
				_fOrientation = fGoal;
			} else {
				var fDirection = 0;
				
				// clamp between PI;-PI
				if ( fDelta > Math.PI )
					fDelta -= Math.PI * 2;
				
				// Get rotation sens ( 1:clockwise or -1: counter clockwise )
				if( fDelta > 0 )
					fDirection = 1;
				else
					fDirection = -1;
					
				// Apply change
				_fOrientation += fDirection * Math.min( Math.abs(fDelta), _fOrientationSpeed );
			}
			
			_fOrientation %= Math.PI*2;
		}
	}

	function _collision_process() :Bool {
		
		// No plan no worry
		if ( _oPlan == null )
			return true;
		
		var oGeometry :Dynamic = null;
		// Get tile on the step area
			var aX :Array<Int> = [ _oPosition.x, ];
			var aY :Array<Int> = [ _oPosition.y, ];
			if ( _oVolume == null ) {
				// Case Vector
				oGeometry = _oPosition;
				
				aX.push( _oPosition.x - _oVelocity.x );
				aX.push( _oPosition.x + _oVelocity.x );
				
				aY.push( _oPosition.y - _oVelocity.y );
				aY.push( _oPosition.y + _oVelocity.y );
			} else {
				oGeometry = _oVolume.geometry_get();
				
				// Else : Assume it's  an Axis Aligned Box
				aX.push( untyped oGeometry.right_get() - _oVelocity.x );
				aX.push( untyped oGeometry.right_get() + _oVelocity.x );
				
				aX.push( untyped oGeometry.left_get() - _oVelocity.x );
				aX.push( untyped oGeometry.left_get() + _oVelocity.x );
				
				aY.push( untyped oGeometry.bottom_get() - _oVelocity.y );
				aY.push( untyped oGeometry.bottom_get() + _oVelocity.y );
				
				aY.push( untyped oGeometry.top_get() - _oVelocity.y );
				aY.push( untyped oGeometry.top_get() + _oVelocity.y );
				
			}
				
			var xMin :Int = aX[0];
			var xMax :Int = aX[0];
			for ( f in aX ) { 
				xMax = IntTool.max( xMax, f );
				xMin = IntTool.min( xMin, f );
			}
			var yMin = aY[0];
			var yMax = aY[0];
			for ( f in aY ) { 
				yMax = IntTool.max( yMax, f );
				yMin = IntTool.min( yMin, f );
			}
			
			// Convert to map coordonate and get list of tile in this area
			var loTile = _oPosition.map_get().tileList_get_byArea( 
				Position.metric_unit_to_maptile( xMin ), 
				Position.metric_unit_to_maptile( xMax ), 
				Position.metric_unit_to_maptile( yMin ), 
				Position.metric_unit_to_maptile( yMax )
			);
			
			// Filter to get only non-walkable tiles
			var loTmp = new List<Tile>();
			for ( oTile in loTile ) {
				if ( !_oPlan.tile_check( oTile ) ) 
					loTmp.push( oTile );
			}
			loTile = loTmp;
			
		// Process
		var oCollisionMin :CollisionEventPriorInt = null;
		var oTileMin :Tile = null;
	
		// Get first collision
		for ( oTile in loTile ) {
			
			// Get collision for current tile
			var oCollision = CollisionCheckerPriorInt.check( 
					oGeometry,
					_oVelocity,
					tileGeometry_get( oTile ),
					null
			);
				
			// Compare collision with the previous to get the first to occur
			if( oCollision != null ) {
				if( oCollisionMin == null ) {
					oCollisionMin = oCollision;
					oTileMin = oTile;
				} else
					//fTimeMin = Math.min( fTimeMin, fTimeCurrent );
					if( oCollision.time_get() < oCollisionMin.time_get() ) {
						oCollisionMin = oCollision;
						oTileMin = oTile;
					}	
				}
		}
		
		// Change velocity upon collsion
		if ( 
			oCollisionMin != null &&
			oCollisionMin.time_get() <= 1 &&
			oCollisionMin.time_get() >= 0
		) {
			_collision_correct( oCollisionMin );
			
			return false;
		} 
			 
		
		return true;
	}
	
	function _collision_correct( oCollisionEvent :CollisionEventPriorInt ) {
		
		// Get time
		var fTime = oCollisionEvent.time_get();
		var fTimeBefore = fTime;
		
		// Get Velocity vector
		var oVector = oCollisionEvent.velocityA_get();
		
		// DEBUG check vector
		if ( oVector.x == 0 && oVector.y == 0 )
			throw '[ERROR]:_collision_correct:Invalid vector';
		
		var i = 1;
		do {
			// Get lowest precision
			var fPres = Math.abs( Math.min( 
				( oVector.x == 0 ) ? 1000000 : 1 / oVector.x, 
				( oVector.y == 0 ) ? 1000000 : 1 / oVector.y
			) );
			
			
			// Update position right before collision
			fTimeBefore = fTime - fPres * i;
			/*
			trace('change : ' + (Math.floor(oVector.x * fTimeBefore) - oVector.x) +
			';'+(Math.floor(oVector.y * fTimeBefore)-oVector.y));*/
			
			// Update position to collision
			oVector.mult( fTimeBefore );
			
			i++;
		} while (
			CollisionCheckerPriorInt.check( 
				oCollisionEvent.shapeA_get(),
				oCollisionEvent.velocityA_get(),
				oCollisionEvent.shapeB_get(),
				oCollisionEvent.VelocityB_get()
			) != null &&
			i != 100
		);
		
		if ( i == 100 )
			throw '[ERROR]:_collision_correct:failed after 100 of attempt';
		
		// Set remaining velocity
		/*
			if( oCollisionEvent.normal_get().x == 1 ) {
				oVector.x = 0;
				oVector.y *= (1-fTime) oCollisionEvent.time_get();
			} else {
				oVector.x *= oCollisionEvent.time_get();
				oVector.y = 0;
			}*/
			
			//!!!!
			//TODO : 
			// MobilityClamp : on collision change position to collision postion
			// 		and change velocity to remaning force with new direction depending on collsion normal
	}
	
//_____________________________________________________________________________
//	Utils
	
	/**
	 * Return the closest valid position of a given point for a given mobility
	 * @param	oMobility
	 * @param	oPoint
	 */
	static public function positionCorrection( oMobility :Mobility, oPoint :Vector2i ) {
		
		// Case no PositionPlan
		if ( oMobility._oPlan == null )
			return oPoint;
		
		// Get map
		var oMap = oMobility.position_get().map_get();
		
		// Case no volume
		var oVolume = oMobility._oVolume;
		if ( oVolume == null ) {
			
			var oTile = oMap.tile_get_byUnitMetric( oPoint.x, oPoint.y );
			if( oMobility._oPlan.tile_check( oTile ) )
				return oPoint;
			
			return null;
		}
		
		// Case volume
		
		// Get target and neightbor Tile
		var lTile = oVolume.tileListProject_get( oPoint.x, oPoint.y );
		
		// Clamp on target tile
		var oResult = oPoint.clone();
		
		var oUnitGeometry = new AlignedAxisBox2i( 
			oMobility._oVolume.size_get(), 
			oMobility._oVolume.size_get(), 
			oPoint 
		);
		
		var oTileGeometry :AlignedAxisBoxAlti;
		for ( oTile in lTile ) {
			// Filter walkable and non colling tile
			if ( oMobility._oPlan.tile_check( oTile ) ) 
				continue;
			
			// Build up tile geometry
			oTileGeometry = tileGeometry_get( oTile );
			
			// Filter non colling tile
			if ( 
				!CollisionCheckerPostInt.check( 
					oUnitGeometry,
					oTileGeometry
				)
			) 
				continue;
			
			//_____
			var iVolumeSize :Int = 0;
			if ( oVolume != null )
				iVolumeSize = oVolume.size_get();
			var dx :Float = oPoint.x/10000 - (oTile.x_get()+0.5);
			var dy :Float = oPoint.y/10000 - (oTile.y_get()+0.5);
			if ( Math.abs(dx) > Math.abs(dy) )
				// Clamp on X axis
				if ( dx > 0 )
					// Goal is on the right side
					oResult.x = oTileGeometry.right_get()+1 + iVolumeSize;
				else
					// Goal is on the left side
					oResult.x = oTileGeometry.left_get()-1 - iVolumeSize;
			else
				// Clamp on Y axis
				if ( dy > 0 )
					// Goal is on the top
					oResult.y = oTileGeometry.top_get()+1 + iVolumeSize;
				else
					// Goal is on the bottom
					oResult.y = oTileGeometry.bottom_get()-1 - iVolumeSize;
		}
		return oResult;
	}
	
	static public function tileGeometry_get( oTile :Tile ) {
		return new AlignedAxisBoxAlti(
			9999, 
			9999, 
			new Vector2i(
				oTile.x_get() * 10000,
				oTile.y_get() * 10000
			) 
		);
	}

}	//END OF class Mobility


private class Force {
	public var oVector :Vector2i;
	public var bLimit :Bool;
}
