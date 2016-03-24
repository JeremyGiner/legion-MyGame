<?php

class collider_CollisionCheckerPostInt {
	public function __construct(){}
	static function check($oShapeA, $oShapeB) {
		$res = collider_CollisionCheckerPostInt::_check($oShapeA, $oShapeB);
		if($res !== null) {
			return $res;
		}
		$res = collider_CollisionCheckerPostInt::_check($oShapeB, $oShapeA);
		if($res !== null) {
			return $res;
		}
		throw new HException("[ERROR]:Collision check:Unable to determine collision between thoses class of shape : " . _hx_string_or_null(Type::getClassName(Type::getClass($oShapeA))) . "; " . _hx_string_or_null(Type::getClassName(Type::getClass($oShapeB))));
		return null;
	}
	static function _check($oShapeA, $oShapeB) {
		if(Std::is($oShapeA, _hx_qtype("space.IAlignedAxisBoxi"))) {
			if(Std::is($oShapeB, _hx_qtype("space.IAlignedAxisBoxi"))) {
				return collider_CollisionCheckerPostInt::_AAB_check($oShapeA, $oShapeB);
			}
			if(Std::is($oShapeB, _hx_qtype("space.Circlei"))) {
				throw new HException("not implemented");
			}
		}
		if(Std::is($oShapeA, _hx_qtype("space.Circlei"))) {
			if(Std::is($oShapeB, _hx_qtype("space.Vector2i"))) {
				return collider_CollisionCheckerPostInt::CircleiPoint_check($oShapeA, $oShapeB);
			}
		}
		if(Std::is($oShapeB, _hx_qtype("space.Circlei"))) {
			return collider_CollisionCheckerPostInt::collisionCircleiCirclei($oShapeA, $oShapeB);
		}
		return null;
	}
	static function collisionCircleiCirclei($oCircleiA, $oCircleiB) {
		$fDelta = space_Vector2i::distance($oCircleiA->position_get(), $oCircleiB->position_get());
		if($fDelta <= $oCircleiA->radius_get() + $oCircleiB->radius_get()) {
			return true;
		} else {
			return false;
		}
	}
	static function CircleiPoint_check($oCirclei, $oPoint) {
		$fDelta = space_Vector2i::distance($oCirclei->position_get(), $oPoint);
		if($fDelta <= $oCirclei->radius_get()) {
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
		return utils_IntTool::min($a2, $b2) - utils_IntTool::max($a1, $b1);
	}
	static function axisCollision2_get($a1, $a2, $b1, $b2) {
		return Math::max($a2, $b2) - Math::min($a1, $b1) <= $a2 - $a1 + ($b2 - $b1);
	}
	function __toString() { return 'collider.CollisionCheckerPostInt'; }
}
