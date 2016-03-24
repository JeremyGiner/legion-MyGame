package mygame.game.collision;

//import collider.CollisionLayer;

import mygame.game.entity.Unit;
import mygame.game.ability.Position;
import mygame.game.ability.Weapon;
import trigger.eventdispatcher.*;
import collider.CollisionEventPrior in CollisionEvent;

import mygame.game.tile.*;

import mygame.game.tile.Tile;

class WeaponLayer {
	
	var _loUnit :List<Unit>;
	var _oCollisionEvent :CollisionEvent = null;
	
	public var onCollision :EventDispatcher;
	public var onUncollision :EventDispatcher;
	
//______________________________________________________________________________
// Constructor

	public function new() {
		_loUnit = new List<Unit>();
		onCollision = new EventDispatcher();
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
		
			for( oTarget in _loUnit ) {
			
				// Check target
				var oWeapon = oUnit.ability_get(Weapon);
				if( oWeapon == null ) continue;
				oWeapon.target_suggest( oTarget );
				
				/* TODO
				// Dispatch collision event
				if( oCollisionMin != null ) {
				
					iCollisionQuantity++;
					_oCollisionEvent = oCollisionMin;
					onCollision.dispatch( 
						oCollisionMin
					);
				}*/
			}
		}
		return iCollisionQuantity;
	}
}