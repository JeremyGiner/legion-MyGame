package mygame.game.collision;

//import collider.CollisionLayer;

import mygame.game.entity.Unit;
import mygame.game.ability.Position;
import mygame.game.ability.LoyaltyShift;

import trigger.eventdispatcher.*;

import collider.CollisionCheckerPost;
//import collider.CollisionEventPrior in CollisionEvent;

import mygame.game.MyGame in Game;


class LoyaltyShiftLayer {
	
	var _oGame :Game;
	var _loUnit :List<Unit>;
	//var _oCollisionEvent :CollisionEvent = null;
	
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
		
		return 0;
	}
}