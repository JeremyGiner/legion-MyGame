<?php

class mygame_server_model_Client extends websocket_SocketDistant implements trigger_ITrigger{
	public function __construct($oResource) {
		if(!php_Boot::$skip_constructor) {
		$this->_iSlotId = -1;
		$this->_oRoom = null;
		parent::__construct($oResource);
		$this->_oMySerializer = new mygame_connection_MySerializer();
		$this->_oMySerializer->useCache = true;
	}}
	public $_oMessageLast;
	public $_oRoom;
	public $_iSlotId;
	public $_oMySerializer;
	public function messageLast_get() {
		return $this->_oMessageLast;
	}
	public function slotId_get() {
		return $this->_iSlotId;
	}
	public function player_get() {
		return $this->_oRoom->game_get()->player_get($this->_iSlotId);
	}
	public function room_get() {
		return $this->_oRoom;
	}
	public function room_set($oRoom, $iSlotId) {
		$this->_oRoom = $oRoom;
		$this->_iSlotId = $iSlotId;
	}
	public function send($oMessage) {
		haxe_Serializer::$USE_CACHE = true;
		if(Std::is($oMessage, _hx_qtype("mygame.connection.message.ReqPlayerInput")) || Std::is($oMessage, _hx_qtype("mygame.connection.message.ResGameStepInput"))) {
			mygame_connection_MySerializer::$_bUSE_RELATIVE = true;
		} else {
			mygame_connection_MySerializer::$_bUSE_RELATIVE = false;
		}
		$this->write(mygame_connection_MySerializer::run($oMessage));
	}
	public function _message_handle() {
		$this->_oMessageLast = mygame_connection_MyUnserializer::run($this->readResult_get(), $this->game_get());
		parent::_message_handle();
	}
	public function trigger($oSource) {}
	public function game_get() {
		if($this->_oRoom === null) {
			return null;
		}
		return $this->_oRoom->game_get();
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
	function __toString() { return 'mygame.server.model.Client'; }
}
