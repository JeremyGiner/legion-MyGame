<?php

class space_AlignedAxisBox2i implements space_IAlignedAxisBoxi{
	public function __construct($fHalfWidth, $fHalfHeight, $oPosition = null) {
		if(!php_Boot::$skip_constructor) {
		$this->_fHalfWidth = $fHalfWidth;
		$this->_fHalfHeight = $fHalfHeight;
		if($oPosition === null) {
			$this->_oPosition = new space_Vector2i(null, null);
		} else {
			$this->_oPosition = $oPosition;
		}
	}}
	public $_fHalfWidth;
	public $_fHalfHeight;
	public $_oPosition;
	public function center_get() {
		return $this->_oPosition;
	}
	public function halfWidth_get() {
		return $this->_fHalfWidth;
	}
	public function width_get() {
		return $this->_fHalfWidth * 2;
	}
	public function height_get() {
		return $this->_fHalfHeight * 2;
	}
	public function halfHeight_get() {
		return $this->_fHalfHeight;
	}
	public function top_get() {
		return $this->_oPosition->y + $this->_fHalfHeight;
	}
	public function bottom_get() {
		return $this->_oPosition->y - $this->_fHalfHeight;
	}
	public function right_get() {
		return $this->_oPosition->x + $this->_fHalfWidth;
	}
	public function left_get() {
		return $this->_oPosition->x - $this->_fHalfWidth;
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
	function __toString() { return 'space.AlignedAxisBox2i'; }
}
