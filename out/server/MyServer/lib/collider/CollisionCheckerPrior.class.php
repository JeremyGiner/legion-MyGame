<?php

class collider_CollisionCheckerPrior {
	public function __construct(){}
	static $_bOb = false;
	static $oCollisionEvent;
	static function check($oShape1, $oVelocity1, $oShape2, $oVelocity2) {
		$res = collider_CollisionCheckerPrior::_check($oShape1, $oVelocity1, $oShape2, $oVelocity2);
		if($res !== null) {
			return call_user_func_array($res, array($oShape1, $oVelocity1, $oShape2, $oVelocity2));
		}
		$res = collider_CollisionCheckerPrior::_check($oShape2, $oVelocity2, $oShape1, $oVelocity1);
		if($res !== null) {
			return call_user_func_array($res, array($oShape2, $oVelocity2, $oShape1, $oVelocity1));
		}
		throw new HException("[ERROR]:Collision check:Unable to determine collision between thoses class of shape : " . _hx_string_or_null(Type::getClassName(Type::getClass($oShape1))) . "; " . _hx_string_or_null(Type::getClassName(Type::getClass($oShape2))));
		return null;
	}
	static function _check($oShapeA, $oVelocity1, $oShapeB, $oVelocity2) {
		if(Std::is($oShapeA, _hx_qtype("space.Vector3"))) {
			if(Std::is($oShapeB, _hx_qtype("space.IAlignedAxisBox"))) {
				return (isset(collider_CollisionCheckerPrior::$_vectorAABB_check) ? collider_CollisionCheckerPrior::$_vectorAABB_check: array("collider_CollisionCheckerPrior", "_vectorAABB_check"));
			}
		}
		if(Std::is($oShapeA, _hx_qtype("space.IAlignedAxisBox"))) {
			if(Std::is($oShapeB, _hx_qtype("space.IAlignedAxisBox"))) {
				return (isset(collider_CollisionCheckerPrior::$_AABB_check) ? collider_CollisionCheckerPrior::$_AABB_check: array("collider_CollisionCheckerPrior", "_AABB_check"));
			}
			if(Std::is($oShapeB, _hx_qtype("space.Circle"))) {
				throw new HException("not implemented");
			}
		}
		if(Std::is($oShapeA, _hx_qtype("space.Circle"))) {
			if(Std::is($oShapeB, _hx_qtype("space.Circle"))) {
				throw new HException("not implemented");
			}
		}
		return null;
	}
	static function _AABB_check($oBox1, $oVelocity1, $oBox2, $oVelocity2) {
		collider_CollisionCheckerPrior::$oCollisionEvent = null;
		$fXCollisionTime = null;
		if(collider_CollisionCheckerPost::axisCollision_get($oBox1->left_get(), $oBox1->right_get(), $oBox2->left_get(), $oBox2->right_get()) > 0) {
			$fXCollisionTime = 0;
		} else {
			if($oVelocity1->x > 0) {
				$fTime = collider_CollisionCheckerPrior::axisCollisionTime_get($oBox1->right_get(), $oVelocity1->x, $oBox2->left_get(), 0);
				if($fTime !== null && $fTime >= 0 && $fTime <= 1) {
					$fXCollisionTime = $fTime;
				}
			} else {
				$fTime = collider_CollisionCheckerPrior::axisCollisionTime_get($oBox1->left_get(), $oVelocity1->x, $oBox2->right_get(), 0);
				if($fTime !== null && $fTime >= 0 && $fTime <= 1) {
					$fXCollisionTime = $fTime;
				}
			}
		}
		$fYCollisionTime = null;
		if(collider_CollisionCheckerPost::axisCollision_get($oBox1->bottom_get(), $oBox1->top_get(), $oBox2->bottom_get(), $oBox2->top_get()) > 0) {
			$fYCollisionTime = 0;
		} else {
			if($oVelocity1->y > 0) {
				$fTime = collider_CollisionCheckerPrior::axisCollisionTime_get($oBox1->top_get(), $oVelocity1->y, $oBox2->bottom_get(), 0);
				if($fTime !== null && $fTime >= 0 && $fTime <= 1) {
					$fYCollisionTime = $fTime;
				}
			} else {
				$fTime = collider_CollisionCheckerPrior::axisCollisionTime_get($oBox1->bottom_get(), $oVelocity1->y, $oBox2->top_get(), 0);
				if($fTime !== null && $fTime >= 0 && $fTime <= 1) {
					$fYCollisionTime = $fTime;
				}
			}
		}
		if($fXCollisionTime === null || $fYCollisionTime === null) {
			return null;
		}
		$oNormal = null;
		if($fXCollisionTime > $fYCollisionTime) {
			$oNormal = new space_Vector3(1, 0, null);
		} else {
			$oNormal = new space_Vector3(0, 1, null);
		}
		collider_CollisionCheckerPrior::$oCollisionEvent = new collider_CollisionEventPrior($oBox1, $oVelocity1, $oBox2, $oVelocity2, Math::max($fXCollisionTime, $fYCollisionTime), $oNormal);
		return collider_CollisionCheckerPrior::$oCollisionEvent;
	}
	static function _vectorAABB_check($oPoint1, $oVelocity1, $oBox2, $oVelocity2) {
		collider_CollisionCheckerPrior::$oCollisionEvent = null;
		$fXCollisionTime = null;
		if(collider_CollisionCheckerPost::axisCollision2_get($oPoint1->x, $oPoint1->x, $oBox2->left_get(), $oBox2->right_get()) === true) {
			$fXCollisionTime = 0;
		} else {
			if($oVelocity1->x > 0) {
				$fTime = collider_CollisionCheckerPrior::axisCollisionTime_get($oPoint1->x, $oVelocity1->x, $oBox2->left_get(), 0);
				if($fTime !== null && $fTime >= 0 && $fTime <= 1) {
					$fXCollisionTime = $fTime;
				}
			} else {
				$fTime = collider_CollisionCheckerPrior::axisCollisionTime_get($oPoint1->x, $oVelocity1->x, $oBox2->right_get(), 0);
				if($fTime !== null && $fTime >= 0 && $fTime <= 1) {
					$fXCollisionTime = $fTime;
				}
			}
		}
		$fYCollisionTime = null;
		if(collider_CollisionCheckerPost::axisCollision2_get($oPoint1->y, $oPoint1->y, $oBox2->bottom_get(), $oBox2->top_get()) === true) {
			$fYCollisionTime = 0;
		} else {
			if($oVelocity1->y > 0) {
				$fTime = collider_CollisionCheckerPrior::axisCollisionTime_get($oPoint1->y, $oVelocity1->y, $oBox2->bottom_get(), 0);
				if($fTime !== null && $fTime >= 0 && $fTime <= 1) {
					$fYCollisionTime = $fTime;
				}
			} else {
				$fTime = collider_CollisionCheckerPrior::axisCollisionTime_get($oPoint1->y, $oVelocity1->y, $oBox2->top_get(), 0);
				if($fTime !== null && $fTime >= 0 && $fTime <= 1) {
					$fYCollisionTime = $fTime;
				}
			}
		}
		if($fXCollisionTime === null || $fYCollisionTime === null) {
			return null;
		}
		$oNormal = null;
		if($fXCollisionTime > $fYCollisionTime) {
			$oNormal = new space_Vector3(1, 0, null);
		} else {
			$oNormal = new space_Vector3(0, 1, null);
		}
		collider_CollisionCheckerPrior::$oCollisionEvent = new collider_CollisionEventPrior($oPoint1, $oVelocity1, $oBox2, $oVelocity2, Math::max($fXCollisionTime, $fYCollisionTime), $oNormal);
		return collider_CollisionCheckerPrior::$oCollisionEvent;
	}
	static function axisCollisionTime_get($p1, $v1, $p2, $v2) {
		$fSpeedDelta = $v1 - $v2;
		if(_hx_equal($fSpeedDelta, 0)) {
			return null;
		}
		return ($p2 - $p1) / $fSpeedDelta;
	}
	function __toString() { return 'collider.CollisionCheckerPrior'; }
}
