package collider;

import space.Vector3 in Vector2;

class CollisionEventPrior {

	var _oDynamicA :Dynamic;
	var _oDynamicB :Dynamic;
	
	var _oVelocityA :Vector2;
	var _oVelocityB :Vector2;
	
	var _fTime :Float;
	
	var _oNormal :Vector2;
	
//______________________________________________________________________________
//	Constructor

	public function new(
		oDynamicA :Dynamic,
		oVelocityA :Vector2,
		oDynamicB :Dynamic,
		oVelocityB :Vector2,
		fTime :Float,
		oNormal :Vector2
	) {
		_oDynamicA = oDynamicA;
		_oDynamicB = oDynamicB;
	
		_oVelocityA = oVelocityA;
		_oVelocityB = oVelocityB;
	
		_fTime = fTime;
		_oNormal = oNormal;
	}
	
//______________________________________________________________________________
//	Accessor

	public function shapeA_get() { return _oDynamicA; }
	public function shapeB_get() { return _oDynamicB; }
	
	public function velocityA_get() { return _oVelocityA; }
	public function VelocityB_get() { return _oVelocityB; }
	
	public function time_get() { return _fTime; }
	
	public function normal_get() { return _oNormal; }
}