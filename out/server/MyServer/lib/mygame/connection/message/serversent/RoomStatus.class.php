<?php

class mygame_connection_message_serversent_RoomStatus implements mygame_connection_message_ILobbyMessage{
	public function __construct($oRoom) {
		if(!php_Boot::$skip_constructor) {
		$this->aUser = new _hx_array(array());
		$this->iGameSpeed = Std::int($oRoom->gameSpeed_get());
		$aPause = $oRoom->pauseList_get();
		{
			$_g1 = 0;
			$_g = $aPause->length;
			while($_g1 < $_g) {
				$i = $_g1++;
				$this->aUser[$i] = new haxe_ds_StringMap();
				_hx_array_get($this->aUser, $i)->set("name", "player" . _hx_string_rec($i, ""));
				_hx_array_get($this->aUser, $i)->set("ready", $aPause[$i]);
				_hx_array_get($this->aUser, $i)->set("playerindex", $i);
				unset($i);
			}
		}
	}}
	public $aUser;
	public $iGameSpeed;
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
	function __toString() { return 'mygame.connection.message.serversent.RoomStatus'; }
}
