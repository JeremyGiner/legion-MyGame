package collider;
import haxe.ds.Vector;
import space.Circle;
import space.Vector3;

import trigger.eventdispatcher.*;

class CollisionLayer {

	var _loCollider :List<Dynamic>;
	
	public var onCollision :EventDispatcher;
	
//_____________________________________________________________________________
// Constructor

	function new() {
		_loCollider = new List<ICollider>();
		onCollision = new EventDispatcher();
	}
	
//_____________________________________________________________________________
// Accessor

	public function collider_add( oCollider :Dynamic ) {
		_loCollider.add( oCollider );
	}
	
	public function collider_remove( oCollider :Dynamic ) {
		_loCollider.remove( oCollider );
	}

//_____________________________________________________________________________
// 

	public function collision_check() {
		
		// Pair of collider modified with all collider except themself
		var loPair :List<ICollider> = ListUtils.exclusifPairing(_loCollider);
		
		// Compute collision test for each pair
		while( !loPair.isEmpty() ) {
			var oCollider1 :ICollider = loPair.pop();
			var oCollider2 :ICollider = loPair.pop();
			
			if( oCollider1.collision_get( oCollider2 ) == null ) {
				
			}
		}
	}
	
}