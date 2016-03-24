<?php

class mygame_connection_message_ReqGameJoin implements mygame_connection_message_ILobbyMessage{
	public function __construct($iGameId, $iSlotId = null) {
		if(!php_Boot::$skip_constructor) {
		if($iSlotId === null) {
			$iSlotId = -1;
		}
		$this->_iGameId = $iGameId;
		$this->_iSlotId = $iSlotId;
	}}
	public $_iGameId;
	public $_iSlotId;
	public function gameId_get() {
		return $this->_iGameId;
	}
	public function slotId_get() {
		return $this->_iSlotId;
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
	function __toString() { return 'mygame.connection.message.ReqGameJoin'; }
}
