package collider;
import space.Circle;
import space.Vector3;
import space.IAlignedAxisBox;


class Collider {

	var _oShape :Circle;
	var _oVelocity :Vector3;
	
	var _oLayer :ColliderLayer;
	
//_____________________________________________________________________________

	public function new( oLayer :ColliderLayer, oPosition :Vector3, fSize :Float ) {
		_oShape = new Circle( oPosition, fSize );
		_oVelocity = new Vector3();
		_oLayer = oLayer;
	}
	
//_____________________________________________________________________________

	function velocity_get():Vector3 {
		return _oVelocity;
	}
	
	function velocity_set( value:Vector3 ):Vector3 {
		return _oVelocity = value;
	}
	
	function shape_get() {
		return _oShape;
	}
	
//_____________________________________________________________________________

	public function 

//_____________________________________________________________________________
	
	private function collisionCircleCircle( oCircle1 :Circle, oCircle2 :Circle ) {
		var fDelta = oCircle1.position_get().distance( oCircle2.position_get() ) );
		var oVector :Vector3 = oCircle2.position_get() - oCircle1.position_get();
		oVector.length_set( fDelta );
		return oVector;
	}
	
	private function collisionRectangleRectangle_check( oBox1 :IAlignedAxisBox, oBox2 :IAlignedAxisBox ) {
		var oDelta = collisionRectangleRectangle_get( Box1, oBox2 );
		
		// Detect classic no collision context : intersect of bounding box is positive
		if ( oDelta.x < 0 )
			return false;
		if ( oDelta.y < 0 )
			return false;
		
		return true;
		
		
		
	}
	
	
	// Sweep collision test for moving AABB against non-moving AABB
	private function sweepBox( oCollider1 :Collider, oCollider2 :Collider ) {
		var oBox1 :IAlignedAxisBox = cast oCollider1.shape_get();
		var oBox2 :IAlignedAxisBox = cast oCollider2.shape_get();
		
		// Sweep on X
		var fXCollisionTime :Float;
		if ( oCollider1.velocity_get().x > 0 ) { 
			// Look for collision on the right(x+) of box1
			fXCollisionTime = axisCollisionTime_get( 
				oBox1.right_get().x,
				oCollider1.velocity_get().x,
				oBox2.left_get().x,
				0
			);
		} else {
			// Look for collision on the left(x-) of box1
			fXCollisionTime = axisCollisionTime_get( 
				oBox1.right_get().x,
				oCollider1.velocity_get().x,
				oBox2.left_get().x,
				0
			);
		}
		if( fXCollisionTime == null ) 
			return;
		
		// Sweep on Y
		var fYCollisionTime :Float;
		if ( oCollider1.velocity_get().y > 0 ) { 
			// Look for collision on the top(y+) of box1
			fYCollisionTime = axisCollisionTime_get( 
				oBox1.top_get().x,
				oCollider1.velocity_get().x,
				oBox2.bottom_get().x,
				0
			);	
		} else {
			// Look for collision on the bottom(y-) of box1
			fYCollisionTime = axisCollisionTime_get( 
				oBox1.bottom_get().x,
				oCollider1.velocity_get().x,
				oBox2.top_get().x,
				0
			);
		}
		if( fXCollisionTime == null ) 
			return;
		
		var fCollsionTime = Math.min( fXCollisionTime, fYCollisionTime );
		if( fCollsionTime > 0 && fCollsionTime < 1 ) {
			// Collision respond
			// TODO : move somewhere else
			oCollider1.velocity_get().mult(fCollsionTime);
		}
	}
	
	public function axisCollisionTime_get( p1 :Float, v1 :Float, p2 :Float, v2 :Float ) {
		var fSpeedDelta = (v1-v2);
		if( fSpeedDelta == 0 ) return null;
		//var collisionTime = (p2-p1) / (v1-v2); //Collision time
		return (p2-p1) / fSpeedDelta; //Collision time
		
		/* 
		T*v1 + p1 = T*v2 + p2
		T*(v1-v2) =  p2 - p1
		T = (p2-p1) / (v1-v2)
		*/
	}
	
	private function collisionRectangleRectangle_get( oBox1 :IAlignedAxisBox, oBox2 :IAlignedAxisBox ) {
		// Get intersection size between two bounding box
		var oDelta = new Vector3( 
			crossSegment( 
				oBox1.positionNext_get().x - oBox1.halfWidth(),
				oBox1.positionNext_get().x + oBox1.halfWidth(),
				oBox2.positionNext_get().x - oBox2.halfWidth(),
				oBox2.positionNext_get().x + oBox2.halfWidth()
			),
			crossSegment( 
				oBox1.positionNext_get().x - oBox1.halfWidth(),
				oBox1.positionNext_get().x + oBox1.halfWidth(),
				oBox2.positionNext_get().x - oBox2.halfWidth(),
				oBox2.positionNext_get().x + oBox2.halfWidth()
			)
		);
		
		var oDelta = new Vector3(
			( oBox1.halfWidth_get() + oBox2.halfWidth_get() )
				- Math.abs( oBox2.positionNext_get().x - oBox1.positionNext_get().x ),
			( oBox1.halfHeight_get() + oBox2.halfHeight_get() )
				- Math.abs( oBox2.positionNext_get().y - oBox1.positionNext_get().y )
		);
	}
	private function collisionCircleRectangle( oCircle :Circle, oAABB :IAlignedAxisBox ) {
		
		// Get intersection size between two bounding box
		var oDelta = new Vector3( 
			( oAABB.halfWidth_get() + oCircle.radius_get() )
				- Math.abs( oCircle.positionNext_get().x - oAABB.positionNext_get().x ),
			( oAABB.halfHeight_get() + oCircle.radius_get() )
				- Math.abs( oCircle.positionNext_get().y - oAABB.positionNext_get().y )
		);
		
		// Detect classic no collision context : intersect of bounding box is positive
		if ( oDelta.x < 0 )
			return null;
		if ( oDelta.y < 0 )
			return null;

		// Detect no collision on remaining context
		var oCorner = new Vector3( 
			oAABB.halfWidth_get(),
			oAABB.halfHeight_get()
		);
		if ( oDelta.distance( oCorner ) > oCircle.radius_get() ) 
			return null;
			
		// Calc ejection vector
		var oEject = new Vector3(
			oCircle.position_get().x - oAABB.position_get().x,
			oCircle.position_get().y - oAABB.position_get().y
		);
		
		if ( oEject.x >= oEject.y ) { 
			oEject.y = 0;
			oEject.length_set( oDelta.x );
		} else {
			oEject.x = 0;
			oEject.length_set( oDelta.y );
		}
		
		return oEject;
		
		// TODO : check velocity > size -> sweep algo
		// TODO : calc ejection vect for corner cases
		/*
		 * circle up/down 
		 * circle right/left
		 * corner
		 */
		
		
	}
	
	public function crossSegment( a1 :Float, a2 :Float, b1 :Float, b2 :Float ) {
		// TODO : check a1<a2 etc..
		return Math.max( a1, b1 ) - Math.min( a2, b2 );
	}
}