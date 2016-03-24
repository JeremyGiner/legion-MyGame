<?php

class space_Circlei {
	public function __construct($oPosition, $iRadius) {
		if(!php_Boot::$skip_constructor) {
		if($oPosition === null) {
			$this->_oPosition = new space_Vector2i(null, null);
		} else {
			$this->_oPosition = $oPosition;
		}
		$this->_fRadius = utils_IntTool::max($iRadius, 0);
	}}
	public $_oPosition;
	public $_fRadius;
	public function radius_get() {
		return $this->_fRadius;
	}
	public function position_get() {
		return $this->_oPosition;
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
	function __toString() { return 'space.Circlei'; }
}
