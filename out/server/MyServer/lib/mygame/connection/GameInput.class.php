<?php

class mygame_connection_GameInput {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->aoPlayerInput = new HList();
	}}
	public $iLoopId;
	public $aoPlayerInput;
	public $_liPlayerInputIndexTemp;
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
	function __toString() { return 'mygame.connection.GameInput'; }
}
