<?php

class space_AlignedAxisBoxAlti implements space_IAlignedAxisBoxi{
	public function __construct($iWidth, $iHeight, $oBottomLeft = null) {
		if(!php_Boot::$skip_constructor) {
		$this->_iWidth = $iWidth;
		$this->_iHeight = $iHeight;
		if($oBottomLeft === null) {
			$this->_oBottomLeft = new space_Vector2i(null, null);
		} else {
			$this->_oBottomLeft = $oBottomLeft;
		}
	}}
	public $_iWidth;
	public $_iHeight;
	public $_oBottomLeft;
	public function width_get() {
		return $this->_iWidth;
	}
	public function height_get() {
		return $this->_iHeight;
	}
	public function haliWidth_get() {
		return $this->_iWidth / 2;
	}
	public function haliHeight_get() {
		return $this->_iHeight / 2;
	}
	public function top_get() {
		return $this->_oBottomLeft->y + $this->_iHeight;
	}
	public function bottom_get() {
		return $this->_oBottomLeft->y;
	}
	public function right_get() {
		return $this->_oBottomLeft->x + $this->_iWidth;
	}
	public function left_get() {
		return $this->_oBottomLeft->x;
	}
	public function bottomLeft_set($x, $y) {
		$this->_oBottomLeft->set($x, $y);
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
	function __toString() { return 'space.AlignedAxisBoxAlti'; }
}
