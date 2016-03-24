package collider;
import haxe.ds.Vector;
import space.Circle;
import space.Vector3;


class ColliderLayer {

	var _loCollider :List<ICollider>;	
	//var _loColliderModified :List<ICollider>;
	
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