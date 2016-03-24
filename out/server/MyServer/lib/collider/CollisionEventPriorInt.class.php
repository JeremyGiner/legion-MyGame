<?php

class collider_CollisionEventPriorInt {
	public function __construct($oDynamicA, $oVelocityA, $oDynamicB, $oVelocityB, $fTime, $oNormal) {
		if(!php_Boot::$skip_constructor) {
		$this->_oDynamicA = $oDynamicA;
		$this->_oDynamicB = $oDynamicB;
		$this->_oVelocityA = $oVelocityA;
		$this->_oVelocityB = $oVelocityB;
		$this->_fTime = $fTime;
		$this->_oNormal = $oNormal;
	}}
	public $_oDynamicA;
	public $_oDynamicB;
	public $_oVelocityA;
	public $_oVelocityB;
	public $_fTime;
	public $_oNormal;
	public function shapeA_get() {
		return $this->_oDynamicA;
	}
	public function shapeB_get() {
		return $this->_oDynamicB;
	}
	public function velocityA_get() {
		return $this->_oVelocityA;
	}
	public function VelocityB_get() {
		return $this->_oVelocityB;
	}
	public function time_get() {
		return $this->_fTime;
	}
	public function normal_get() {
		return $this->_oNormal;
	}
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->__dynamics[$m]) && is_callable($this->__dynamics[$m]))
			return call_user_func_array($this->__dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call <'.$m.'>');
	}
	function __toString() { return 'collider.CollisionEventPriorInt'; }
}
