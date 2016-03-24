<?php

class mygame_connection_message_MesPlayerInput implements mygame_connection_message_IGameMessage{
	public function __construct($oAction) {}
	public $_sSerial;
	public $_oAction;
	public function action_get($oPlayer) {
		if(!php_Boot::$skip_constructor) {
		return null;
	}}
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
	function __toString() { return 'mygame.connection.message.MesPlayerInput'; }
}
