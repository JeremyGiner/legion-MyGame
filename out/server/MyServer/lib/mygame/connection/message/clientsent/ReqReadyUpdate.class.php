<?php

class mygame_connection_message_clientsent_ReqReadyUpdate implements mygame_connection_message_ILobbyMessage{
	public function __construct($bReady) {
		if(!php_Boot::$skip_constructor) {
		$this->_bReady = $bReady;
	}}
	public $_bReady;
	public function ready_get() {
		return $this->_bReady;
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
	function __toString() { return 'mygame.connection.message.clientsent.ReqReadyUpdate'; }
}
