package collider;

import haxe.ds.Vector;
import space.Circle;
import space.Vector3;

import trigger.*;

class ColliderLayer {

	var _loCollider :List<ICollider>;	
	//var _loColliderModified :List<ICollider>;
	
	var _fCollisionLastTime :Float;	// Percent of virtual step time between current step and the next
	var _fCollisionLastCollider1 :ICollider;
	var _fCollisionLastCollider2 :ICollider;
	
	public var onCollision :EventDispatcher;
	
//_____________________________________________________________________________
// Constructor

	public function new() {
		_loCollider = new List<ICollider>();
		//_loColliderModified = new List<ICollider>();
	}
	
//_____________________________________________________________________________
// Accessor

	public function collider_add( oCollider :ICollider ) {
		_loCollider.add( oCollider );
		//_loColliderModified.add( oCollider );
	}
	
	public function collider_remove( oCollider :ICollider ) {
		_loCollider.remove( oCollider );
		//_loColliderModified.remove( oCollider );
	}

//_____________________________________________________________________________
// 
	/*
	 *	Description : detect the earliest collision
	 */
	public function collision_check() {
		
		// Clean up
		_fCollisionLastTime = null;
		
		// Pair of collider modified with all collider except themself
		var loPair :List<ICollider> = ListUtils.exclusifPairing(_loCollider);
		
		// Compute collision test for each pair
		while( !loPair.isEmpty() ) {
			var oCollider1 :ICollider = loPair.pop();
			var oCollider2 :ICollider = loPair.pop();
			
			var fCollisionTime = CollisionUtils.collisionPrior_check( 
				oCollider1, 
				oVelocity1,
				oCollider2,
				oVelocity2
			);
		
			// Check if valid result ( invalid mean never collide )
			if( fCollisionTime == null )
				continue;
			
			// Check if new collision is earlier than the current one
			if( 
				_fCollisionLastTime == null || 
				_fCollisionLastTime > fCollisionTime
			) {
				_fCollisionLastTime = fCollisionTime;
				_fCollisionLastCollider1 = oCollider1;
				_fCollisionLastCollider2 = oCollider2;
				onCollision.dispatch( this );
			}
		}
		
		
	}
	
}