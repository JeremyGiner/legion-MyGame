<?php

class mygame_connection_message_ResSlotList implements mygame_connection_message_ILobbyMessage{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->liGameId = new HList();
	}}
	public $liGameId;
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
	function __toString() { return 'mygame.connection.message.ResSlotList'; }
}
