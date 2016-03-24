<?php

class mygame_connection_message_serversent_ResError implements mygame_connection_message_ILobbyMessage{
	public function __construct($iId, $sMessage) {
		if(!php_Boot::$skip_constructor) {
		$this->_iId = $iId;
		$this->_sMessage = $sMessage;
	}}
	public $_iId;
	public $_sMessage;
	public function id_get() {
		return $this->_iId;
	}
	public function message_get() {
		return $this->_sMessage;
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
	function __toString() { return 'mygame.connection.message.serversent.ResError'; }
}
