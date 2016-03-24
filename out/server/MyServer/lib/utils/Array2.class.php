<?php

class utils_Array2 {
	public function __construct($x) {
		if(!php_Boot::$skip_constructor) {
		$this->pitch = $x;
		$this->_aoArray = new _hx_array(array());
	}}
	public function pitch_get() {
		return $this->pitch;
	}
	public function set($x, $y, $oValue) {
		$this->_aoArray[$x + $y * $this->pitch] = $oValue;
	}
	public function get($x, $y) {
		return $this->_aoArray[$x + $y * $this->pitch];
	}
	public $_aoArray;
	public $pitch;
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
	function __toString() { return 'utils.Array2'; }
}
