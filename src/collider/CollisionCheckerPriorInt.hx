package collider;

import space.IAlignedAxisBoxi;
import space.Vector2i;
import space.Circle;
import space.IAlignedAxisBox;
import collider.CollisionEventPriorInt in CollisionEvent;

class CollisionCheckerPriorInt {
	
	static var _bOb :Bool = false; // Bob the boolean
	
	public static var oCollisionEvent :CollisionEvent;

//_____________________________________________________________________________
// Checker

	public static function check( 
		oShape1 :Dynamic,
		oVelocity1 :Vector2i,
		oShape2 :Dynamic,
		oVelocity2 :Vector2i
	) :CollisionEvent {
		
		var res = _check( oShape1, oVelocity1, oShape2, oVelocity2 );
		if ( res != null ) 
			return res( oShape1, oVelocity1, oShape2, oVelocity2 );
		
		// If invalid then try to swp shape
		res = _check( oShape2, oVelocity2, oShape1, oVelocity1 );
		if( res != null ) return res( oShape2, oVelocity2, oShape1, oVelocity1 );
		
		// Throw error for unimplemented class of shape
		throw('[ERROR]:Collision check:Unable to determine collision between thoses class of shape : '+Type.getClassName(Type.getClass(oShape1))+'; '+Type.getClassName(Type.getClass(oShape2)));
		return null;
	}

	static function _check( 
		oShapeA :Dynamic,
		oVelocity1 :Vector2i,
		oShapeB :Dynamic,
		oVelocity2 :Vector2i
	) :Dynamic->Dynamic->Dynamic->Dynamic->CollisionEvent {
		
		// Point againt ?
		if ( Std.is( oShapeA, Vector2i ) ) {
			if ( Std.is( oShapeB, IAlignedAxisBoxi ) )
				return _vectorAABB_check;
		}
		
		// AABB against ?
		if( Std.is( oShapeA, IAlignedAxisBoxi ) ) {
			if ( Std.is( oShapeB, IAlignedAxisBoxi ) )
				return _AABB_check;
				
			if( Std.is( oShapeB, Circle ) )
				throw('not implemented');
		}
		
		if( Std.is( oShapeA, Circle ) )
			/*if( Std.is( oShapeB, Vector2 ) )
				throw('not implemented');*/
			if( Std.is( oShapeB, Circle ) )
				throw('not implemented');
		
		return null;
	}
	
//_____________________________________________________________________________
//	Sub-checker
	
	static function _AABB_check( 
		oBox1 :IAlignedAxisBoxi,
		oVelocity1 :Vector2i,
		oBox2 :IAlignedAxisBoxi,
		oVelocity2 :Vector2i
	) :CollisionEvent {
		// TODO : case collision already occure
		// TODO : use velocity2
		
		// Cleaning
		oCollisionEvent = null;
		
		// Look for collision on X
		var fXCollisionTime :Float = null;
		if( 
			CollisionCheckerPost.axisCollision_get( 
				oBox1.left_get(),
				oBox1.right_get(), 
				oBox2.left_get(),
				oBox2.right_get()
			) > 0 
		) {
			fXCollisionTime = 0;
		} else {
		
			// Sweep on X
			if ( oVelocity1.x > 0 ) { 
				// Look for collision on the right(x+) of box1
				var fTime = axisCollisionTime_get( 
					oBox1.right_get(),
					oVelocity1.x,
					oBox2.left_get(),
					0
				);
				if( fTime != null && fTime >= 0 && fTime <= 1  )
					fXCollisionTime = fTime;
			} else {
				// Look for collision on the left(x-) of box1
				var fTime = axisCollisionTime_get( 
					oBox1.left_get(),
					oVelocity1.x,
					oBox2.right_get(),
					0
				);
				if( fTime != null && fTime >= 0 && fTime <= 1  )
					fXCollisionTime = fTime;
			}
		}
		
		// Look for collision on Y
		var fYCollisionTime :Float = null;
		
		if( 
			CollisionCheckerPost.axisCollision_get( 
				oBox1.bottom_get(), 
				oBox1.top_get(),
				oBox2.bottom_get(),
				oBox2.top_get()
			) > 0 
		) {
			fYCollisionTime = 0;
		} else {
			// Sweep on Y
			if ( oVelocity1.y > 0 ) { 
				// Look for collision on the top(y+) of box1
				var fTime = axisCollisionTime_get( 
					oBox1.top_get(),
					oVelocity1.y,
					oBox2.bottom_get(),
					0
				);
				if( fTime != null && fTime >= 0 && fTime <= 1  )
					fYCollisionTime = fTime;
			} else {
				// Look for collision on the bottom(y-) of box1
				var fTime = axisCollisionTime_get( 
					oBox1.bottom_get(),
					oVelocity1.y,
					oBox2.top_get(),
					0
				);
				if( fTime != null && fTime >= 0 && fTime <= 1  )
					fYCollisionTime = fTime;
			}
		}
		//trace('X : '+fXCollisionTime+'; Y : ' + fYCollisionTime);
		
		// Process collision time on X and Y
		if( fXCollisionTime == null || fYCollisionTime == null )
			return null;
		
		// Get normal
		// if we define dx=x2-x1 and dy=y2-y1, then the normals are (-dy, dx) and (dy, -dx).
		var oNormal :Vector2i = null;
		if( fXCollisionTime > fYCollisionTime )
			oNormal = new Vector2i( 1, 0 );
		else
			oNormal = new Vector2i( 0, 1 );
		
		// Return collision
		oCollisionEvent = new CollisionEvent(
			oBox1,
			oVelocity1,
			oBox2,
			oVelocity2,
			Math.max( fXCollisionTime, fYCollisionTime ),
			oNormal
		);
		
		return oCollisionEvent;
	}
	
	static function _vectorAABB_check( 
		oPoint1 :Vector2i,
		oVelocity1 :Vector2i,
		oBox2 :IAlignedAxisBoxi,
		oVelocity2 :Vector2i
	) :CollisionEvent {
		// TODO : case collision already occure
		// TODO : use velocity2
		
		// Cleaning
		oCollisionEvent = null;
		
		// Look for collision on X
		var fXCollisionTime :Float = null;
		if ( 
			CollisionCheckerPost.axisCollision2_get( 
				oPoint1.x,
				oPoint1.x, 
				oBox2.left_get(),
				oBox2.right_get()
			) == true
		) {
			fXCollisionTime = 0;
		} else {
		
			// Sweep on X
			if ( oVelocity1.x > 0 ) { 
				// Look for collision on the right(x+) of box1
				var fTime = axisCollisionTime_get( 
					oPoint1.x,
					oVelocity1.x,
					oBox2.left_get(),
					0
				);
				if( fTime != null && fTime >= 0 && fTime <= 1  )
					fXCollisionTime = fTime;
			} else {
				// Look for collision on the left(x-) of box1
				var fTime = axisCollisionTime_get( 
					oPoint1.x,
					oVelocity1.x,
					oBox2.right_get(),
					0
				);
				if( fTime != null && fTime >= 0 && fTime <= 1  )
					fXCollisionTime = fTime;
			}
		}
		
		// Look for collision on Y
		var fYCollisionTime :Float = null;
		if( 
			CollisionCheckerPost.axisCollision2_get( 
				oPoint1.y, 
				oPoint1.y, 
				oBox2.bottom_get(),
				oBox2.top_get()
			) == true 
		) {
			fYCollisionTime = 0;
		} else {
			// Sweep on Y
			if ( oVelocity1.y > 0 ) { 
				// Look for collision on the top(y+) of box1
				var fTime = axisCollisionTime_get( 
					oPoint1.y,
					oVelocity1.y,
					oBox2.bottom_get(),
					0
				);
				if( fTime != null && fTime >= 0 && fTime <= 1  )
					fYCollisionTime = fTime;
			} else {
				// Look for collision on the bottom(y-) of box1
				var fTime = axisCollisionTime_get( 
					oPoint1.y,
					oVelocity1.y,
					oBox2.top_get(),
					0
				);
				if( fTime != null && fTime >= 0 && fTime <= 1  )
					fYCollisionTime = fTime;
			}
		}
		
		// Process collision time on X and Y
		if( fXCollisionTime == null || fYCollisionTime == null )
			return null;
		
		// Get normal
		// if we define dx=x2-x1 and dy=y2-y1, then the normals are (-dy, dx) and (dy, -dx).
		var oNormal :Vector2i = null;
		if( fXCollisionTime > fYCollisionTime )
			oNormal = new Vector2i( 1, 0 );
		else
			oNormal = new Vector2i( 0, 1 );
		
		// Return collision
		oCollisionEvent = new CollisionEvent (
			oPoint1,
			oVelocity1,
			oBox2,
			oVelocity2,
			Math.max( fXCollisionTime, fYCollisionTime ),
			oNormal
		);
		
		return oCollisionEvent;
	}
//_____________________________________________________________________________
// Sub-functions
	
	public static function axisCollisionTime_get( p1 :Int, v1 :Int, p2 :Int, v2 :Int ) {
		var fSpeedDelta = (v1-v2);
		if( fSpeedDelta == 0 ) return null;
		//var collisionTime = (p2-p1) / (v1-v2); //Collision time
		//trace( 'collsion time : ' + ((p2-p1) / fSpeedDelta) );
		return (p2-p1) / fSpeedDelta; //Collision time
		
		/* 
		T*v1 + p1 = T*v2 + p2
		T*(v1-v2) =  p2 - p1
		T = (p2-p1) / (v1-v2)
		*/
	}
}