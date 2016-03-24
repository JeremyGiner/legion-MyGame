<?php

class mygame_connection_message_ResGameStepInput implements mygame_connection_message_IGameMessage{
	public function __construct($iLoopId, $loInput) {
		if(!php_Boot::$skip_constructor) {
		$this->_iLoopId = $iLoopId;
		$this->_loInput = $loInput;
	}}
	public $_iLoopId;
	public $_loInput;
	public function loopId_get() {
		return $this->_iLoopId;
	}
	public function inputList_get() {
		return $this->_loInput;
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
	function __toString() { return 'mygame.connection.message.ResGameStepInput'; }
}
