package collider;

import space.Vector3;
import space.Vector3 in Vector2;
import space.IAlignedAxisBox;
import space.Circle;

class CollisionCheckerPost {
	
	static var _oCollisionVector :Vector2 = null;
	
//_____________________________________________________________________________
// Checker

	public static function check( oShapeA :Dynamic, oShapeB :Dynamic ) :Bool {
		
		var res = _check( oShapeA, oShapeB );
		if( res != null ) return res;
		
		// If invalid then try to swp shape
		res = _check( oShapeB, oShapeA );
		if( res != null ) return res;
		
		// Throw error for unimplemented class of shape
		throw('[ERROR]:Collision check:Unable to determine collision between thoses class of shape : '+Type.getClassName(Type.getClass(oShapeA))+'; '+Type.getClassName(Type.getClass(oShapeB)));
		return null;
	}

	static function _check(  oShapeA :Dynamic, oShapeB :Dynamic ) :Bool {
		
		if( Std.is( oShapeA, IAlignedAxisBox ) ) {
			if ( Std.is( oShapeB, IAlignedAxisBox ) )
				return _AAB_check( cast oShapeA, cast oShapeB );
				
			if( Std.is( oShapeB, Circle ) )
				throw('not implemented');
		}
		
		if( Std.is( oShapeA, Circle ) )
			if( Std.is( oShapeB, Vector2 ) )
				return circlePoint_check( cast oShapeA, cast oShapeB );
			if( Std.is( oShapeB, Circle ) )
				return collisionCircleCircle( cast oShapeA, cast oShapeB );
		
		return null;
	}


//_____________________________________________________________________________
// Sub-functions

	static function collisionCircleCircle( 
		oCircleA :Circle, 
		oCircleB :Circle 
	) {
		var fDelta = Vector3.distance( 
			oCircleA.position_get(),
			oCircleB.position_get() 
		);
		//var oVector :Vector3 = oCircle2.position_get() - oCircle1.position_get();
		//oVector.length_set( fDelta );
		//return oVector;
		if( fDelta <= oCircleA.radius_get() + oCircleB.radius_get() )
			return true;	//Collision
		else
			return false; 	//No collision
	}
	
	static function circlePoint_check( oCircle :Circle, oPoint :Vector2  ) {
		var fDelta = Vector3.distance( 
			oCircle.position_get(),
			oPoint 
		);

		if( fDelta <= oCircle.radius_get() )
			return true;	//Collision
		else
			return false; 	//No collision
	}
	
	static function _AAB_check( oBoxA :IAlignedAxisBox, oBoxB :IAlignedAxisBox ) :Bool {
		
		if ( CollisionCheckerPost.axisCollision_get( 
					oBoxA.left_get(),
					oBoxA.right_get(), 
					oBoxB.left_get(),
					oBoxB.right_get()
				) < 0
		) return false;	//No collision
		
		if( CollisionCheckerPost.axisCollision_get( 
				oBoxA.bottom_get(), 
				oBoxA.top_get(),
				oBoxB.bottom_get(),
				oBoxB.top_get()
			) < 0
		) return false;	//No collision
		
		return true;	//Collision
	}
	/*
	static function collisionRectangleRectangle_check( oBox1 :IAlignedAxisBox, oBox2 :IAlignedAxisBox ) {
		var oDelta = collisionRectangleRectangle_get( Box1, oBox2 );
		
		// Detect classic no collision context : intersect of bounding box is positive
		if ( oDelta.x < 0 )
			return false;
		if ( oDelta.y < 0 )
			return false;
		
		return true;
	}
	
	static function collisionRectangleRectangle_get( oBox1 :IAlignedAxisBox, oBox2 :IAlignedAxisBox ) {
		// Get intersection size between two bounding box
		var oDelta = new Vector3( 
			crossSegment( 
				oBox1.positionNext_get().x - oBox1.halfWidth_get(),
				oBox1.positionNext_get().x + oBox1.halfWidth_get(),
				oBox2.positionNext_get().x - oBox2.halfWidth_get(),
				oBox2.positionNext_get().x + oBox2.halfWidth_get()
			),
			crossSegment( 
				oBox1.positionNext_get().x - oBox1.halfWidth_get(),
				oBox1.positionNext_get().x + oBox1.halfWidth_get(),
				oBox2.positionNext_get().x - oBox2.halfWidth_get(),
				oBox2.positionNext_get().x + oBox2.halfWidth_get()
			)
		);
		
		var oDelta = new Vector3(
			( oBox1.halfWidth_get_get() + oBox2.halfWidth_get_get() )
				- Math.abs( oBox2.positionNext_get().x - oBox1.positionNext_get().x ),
			( oBox1.halfHeight_get() + oBox2.halfHeight_get() )
				- Math.abs( oBox2.positionNext_get().y - oBox1.positionNext_get().y )
		);
	}*/
	/*
	static function collisionCircleRectangle( oCircle :Circle, oAABB :IAlignedAxisBox ) {
		
		// Get intersection size between two bounding box
		var oDelta = new Vector3( 
			( oAABB.halfWidth_get_get() + oCircle.radius_get() )
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
		//circle up/down 
		//circle right/left
		//corner
		//
		
		
	}*/

	/**
	 * Return collision vector with A object as reference
	 * or null if no collision
	 * 
	 * 			 A1-----A2
	 * B1-----B2
	 * => null
	 * 
	 * 		A1-----A2
	 * B1-----B2
	 * => 1
	 * 
	 * A1-----A2
	 * 		B1-----B2
	 * => -1
	 * 
	 * A1-----A2
	 * 			 B1-----B2
	 * => null
	 * 
	 * A1---------------A2
	 * 		B1----B2
	 * => ???
	 * 
	 * @param	a1 Minimal edge of first object
	 * @param	a2 Maximal edge of first object
	 * @param	b1 Minimal edge of second object
	 * @param	b2 Maximal edge of second object
	 * 
	 * @return	
	 */
	/*public static function axisCollisionVector_get( a1 :Float, a2 :Float, b1 :Float, b2 :Float ) :Float {
		// TODO : check a1<a2 etc..
		
		// If b2 between a1 and a2
		if ( a1 < b2 && b2 > a2 )
			return a1 - b2;
		// If b1 between a1 and a2
		if ( a1 < b1 && b1 > a2 )
			return a1 - b2;
			
		
		return Math.min( a2, b2 ) - Math.max( a1, b1 );
	}*/
	
	/**
	 * If result inferior 0, then NO collision
	 * 
	 * 			 A1-----A2
	 * B1-----B2
	 * => (-) delta A1,B2
	 * 
	 * 		A1-----A2
	 * B1-----B2
	 * => (+) delta A1,B2
	 * 
	 * A1-----A2
	 * 		B1-----B2
	 * => (+) delta B1,A2
	 * 
	 * A1-----A2
	 * 			 B1-----B2
	 * => (-) delta A2,B1
	 * 
	 * A1---------------A2
	 * 		B1----B2
	 * => (+) delta B1,B2
	 * @param	a1 Minimal edge of first object
	 * @param	a2 Maximal edge of first object
	 * @param	b1 Minimal edge of second object
	 * @param	b2 Maximal edge of second object
	 * 
	 * @return	delta of the object intersection 
	 * 	(or a negative value corresponding to the gap size between the two objects ).
	 */
	public static function axisCollision_get( a1 :Float, a2 :Float, b1 :Float, b2 :Float ) :Float {
		// TODO : check a1<a2 etc..
		return Math.min( a2, b2 ) - Math.max( a1, b1 );
	}
	

	/**
	 * True : collison
	 * False : NO collision
	 */
	public static function axisCollision2_get( a1 :Float, a2 :Float, b1 :Float, b2 :Float ) :Bool {
		return (
			Math.max( a2, b2 ) - Math.min( a1, b1 )	// 'Complete' size of intervals
		) <= ( 
			(a2 - a1) + (b2 - b1) 	// Sum of size of each interval
		);
	}
}