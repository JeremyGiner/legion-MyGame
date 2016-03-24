package mygame.game.collision;

//import collider.CollisionLayer;

import mygame.game.entity.Unit;
import mygame.game.ability.Position;
import mygame.game.ability.PositionPlan;
import mygame.game.ability.Mobility;
import mygame.game.ability.Volume;
import mygame.game.ability.Guidance;
import trigger.*;
import collider.CollisionCheckerPrior;
import collider.CollisionEventPrior in CollisionEvent;

import mygame.game.tile.*;

import mygame.game.tile.Tile;

class UnitTile {
	
	var _loUnit :List<Unit>;
	var _oCollisionEvent :CollisionEvent = null;
	
	public var onCollision :EventDispatcher2<CollisionEvent>;
	
//______________________________________________________________________________
// Constructor

	public function new() {
		_loUnit = new List<Unit>();
		onCollision = new EventDispatcher2<CollisionEvent>();
	}
	
//______________________________________________________________________________
// Accessor

	public function add( oUnit :Unit ) { _loUnit.add( oUnit ); }
	public function remove( oUnit :Unit ) { _loUnit.remove( oUnit ); }
	
	public function collisionEventLast_get() { return _oCollisionEvent; }

//______________________________________________________________________________
// Collision
	
	public function collision_check() :Int {
	
		var iCollisionQuantity :Int = 0;
	
		// Collision check between a unit mobility 
		// and his surrounding (non-walkable) tiles.
		for( oUnit in _loUnit ) {
		
			// Get list of tiles around unit
			var oPosition = oUnit.ability_get(Position);
			var oPlan = oUnit.ability_get( PositionPlan );
			var loTile = oPosition.map_get().tileList_gather(
				oPosition.tile_get()
			);
			//TODO : get only non-walking tile
			
			// Get time and tile of the first collision to occur for current unit
			var oCollisionMin :CollisionEvent = null;
			var oTileMin :Tile = null;
			for( oTile in loTile ) {
			
				// Skip walkable tile
				if( oPlan.tile_check(oTile) )
					continue;
			
				// Get collision for current tile
				var oCollision = CollisionCheckerPrior.check( 
					oUnit.ability_get( Volume ).geometry_get(),
					oUnit.ability_get( Mobility ).velocity_get(), 
					oTile.geometry_get(),
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
			
			// Dispatch collision event
			if( oCollisionMin != null ) {
			
				iCollisionQuantity++;
				_oCollisionEvent = oCollisionMin;
				onCollision.dispatch( 
					oCollisionMin
				);
			}
		}
		return iCollisionQuantity;
	}
	
//______________________________________________________________________________
// Other
	
}