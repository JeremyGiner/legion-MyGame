<?php

class collider_CollisionCheckerPost {
	public function __construct(){}
	static $_oCollisionVector = null;
	static function check($oShapeA, $oShapeB) {
		$res = collider_CollisionCheckerPost::_check($oShapeA, $oShapeB);
		if($res !== null) {
			return $res;
		}
		$res = collider_CollisionCheckerPost::_check($oShapeB, $oShapeA);
		if($res !== null) {
			return $res;
		}
		throw new HException("[ERROR]:Collision check:Unable to determine collision between thoses class of shape : " . _hx_string_or_null(Type::getClassName(Type::getClass($oShapeA))) . "; " . _hx_string_or_null(Type::getClassName(Type::getClass($oShapeB))));
		return null;
	}
	static function _check($oShapeA, $oShapeB) {
		if(Std::is($oShapeA, _hx_qtype("space.IAlignedAxisBox"))) {
			if(Std::is($oShapeB, _hx_qtype("space.IAlignedAxisBox"))) {
				return collider_CollisionCheckerPost::_AAB_check($oShapeA, $oShapeB);
			}
			if(Std::is($oShapeB, _hx_qtype("space.Circle"))) {
				throw new HException("not implemented");
			}
		}
		if(Std::is($oShapeA, _hx_qtype("space.Circle"))) {
			if(Std::is($oShapeB, _hx_qtype("space.Vector3"))) {
				return collider_CollisionCheckerPost::circlePoint_check($oShapeA, $oShapeB);
			}
		}
		if(Std::is($oShapeB, _hx_qtype("space.Circle"))) {
			return collider_CollisionCheckerPost::collisionCircleCircle($oShapeA, $oShapeB);
		}
		return null;
	}
	static function collisionCircleCircle($oCircleA, $oCircleB) {
		$fDelta = space_Vector3::distance($oCircleA->position_get(), $oCircleB->position_get());
		if($fDelta <= $oCircleA->radius_get() + $oCircleB->radius_get()) {
			return true;
		} else {
			return false;
		}
	}
	static function circlePoint_check($oCircle, $oPoint) {
		$fDelta = space_Vector3::distance($oCircle->position_get(), $oPoint);
		if($fDelta <= $oCircle->radius_get()) {
			return true;
		} else {
			return false;
		}
	}
	static function _AAB_check($oBoxA, $oBoxB) {
		if(collider_CollisionCheckerPost::axisCollision_get($oBoxA->left_get(), $oBoxA->right_get(), $oBoxB->left_get(), $oBoxB->right_get()) < 0) {
			return false;
		}
		if(collider_CollisionCheckerPost::axisCollision_get($oBoxA->bottom_get(), $oBoxA->top_get(), $oBoxB->bottom_get(), $oBoxB->top_get()) < 0) {
			return false;
		}
		return true;
	}
	static function axisCollision_get($a1, $a2, $b1, $b2) {
		return Math::min($a2, $b2) - Math::max($a1, $b1);
	}
	static function axisCollision2_get($a1, $a2, $b1, $b2) {
		return Math::max($a2, $b2) - Math::min($a1, $b1) <= $a2 - $a1 + ($b2 - $b1);
	}
	function __toString() { return 'collider.CollisionCheckerPost'; }
}
