package mygame.game.collision;

//import collider.CollisionLayer;

import mygame.game.entity.Unit;
import mygame.game.entitytrait.Mobility;
import trigger.eventdispatcher.*;
import collider.CollisionCheckerPrior;
import collider.CollisionEventPrior in CollisionEvent;

import mygame.game.tile.Tile;

class UnitTile {
	
	var _loUnit :List<Unit>;
	var _loMobility :List<Mobility>;
	var _oCollisionEvent :CollisionEvent;
	
	public var onCollision :EventDispatcher;
	
//______________________________________________________________________________
// Constructor

	public function new() {
		_loUnit = new List<Unit>();
		_loMobility = new List<Mobility>();
		onCollision = new EventDispatcher();
	}
	
//______________________________________________________________________________
// Accessor

	public function add( oUnit :Unit ) { _loUnit.add( oUnit ); }
	public function remove( oUnit :Unit ) { _loUnit.remove( oUnit ); }
	
	public function collider_add( oCollider :Mobility ) {
		_loMobility.add( oCollider );
	}
	
	public function collider_remove( oCollider :Mobility ) {
		_loMobility.remove( oCollider );
	}

//______________________________________________________________________________
// Collision
	
	public function collision_check() :Int {
	
		var iCollisionQuantity :Int = 0;
	
		// Collision check between a unit mobility 
		// and his surrounding (non-walkable) tiles.
		for( oMobility in _loMobility ) {
		
			// Get list of tiles around unit
			var loTile = oMobility.tile_gather();//TODO : get only non-walking tile
			
			// Get time and tile of the first collision of current mobility
			var oCollisionMin :CollisionEvent = null;
			var oTileMin :Tile = null;
			for( oTile in loTile ) {
			
				var oCollision = CollisionCheckerPrior.check( 
					oMobility.geometry_get(),
					oMobility.velocity_get(), 
					oTile.geometry_get(),
					null
				);
				
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
			
			// Dispatch collision event
			if( oCollisionMin != null ) {
			
				iCollisionQuantity++;
				
				onCollision.dispatch( 
					oCollisionMin
				);
			}
		}
		return iCollisionQuantity;
	}
}