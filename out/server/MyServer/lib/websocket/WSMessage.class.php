<?php

class websocket_WSMessage {
	public function __construct($iOpCode, $sPayload) {
		if(!php_Boot::$skip_constructor) {
		$this->_iOpCode = $iOpCode;
		$this->_sPayload = $sPayload;
	}}
	public $_iOpCode;
	public $_sPayload;
	public function opcode_get() {
		return $this->_iOpCode;
	}
	public function payload_get() {
		return $this->_sPayload;
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
	function __toString() { return 'websocket.WSMessage'; }
}
