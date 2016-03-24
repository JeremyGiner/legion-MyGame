<?php

class space_AlignedAxisBoxAlt implements space_IAlignedAxisBox{
	public function __construct($fWidth, $fHeight, $oBottomLeft = null) {
		if(!php_Boot::$skip_constructor) {
		$this->_fWidth = $fWidth;
		$this->_fHeight = $fHeight;
		if($oBottomLeft === null) {
			$this->_oBottomLeft = new space_Vector3(null, null, null);
		} else {
			$this->_oBottomLeft = $oBottomLeft;
		}
	}}
	public $_fWidth;
	public $_fHeight;
	public $_oBottomLeft;
	public function center_get() {
		return new space_Vector3($this->_oBottomLeft->x + $this->halfWidth_get(), $this->_oBottomLeft->y + $this->halfHeight_get(), null);
	}
	public function width_get() {
		return $this->_fWidth;
	}
	public function height_get() {
		return $this->_fHeight;
	}
	public function halfWidth_get() {
		return $this->_fWidth / 2;
	}
	public function halfHeight_get() {
		return $this->_fHeight / 2;
	}
	public function top_get() {
		return $this->_oBottomLeft->y + $this->_fHeight;
	}
	public function bottom_get() {
		return $this->_oBottomLeft->y;
	}
	public function right_get() {
		return $this->_oBottomLeft->x + $this->_fWidth;
	}
	public function left_get() {
		return $this->_oBottomLeft->x;
	}
	public function bottomLeft_set($x, $y) {
		$this->_oBottomLeft->set($x, $y, null);
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
	function __toString() { return 'space.AlignedAxisBoxAlt'; }
}
