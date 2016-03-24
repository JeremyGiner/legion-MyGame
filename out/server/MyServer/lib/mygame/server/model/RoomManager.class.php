<?php

class mygame_server_model_RoomManager {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->_moRoom = new haxe_ds_IntMap();
		$this->_moGameInput = new haxe_ds_IntMap();
		$this->onAnyProcessStart = new trigger_eventdispatcher_EventDispatcher();
		$this->onAnyRoomUpdate = new trigger_eventdispatcher_EventDispatcherFunel();
	}}
	public $_moRoom;
	public $_moGameInput;
	public $onAnyProcessStart;
	public $onAnyRoomUpdate;
	public function game_get($iGameId) {
		return $this->_moRoom->get($iGameId);
	}
	public function roomList_get() {
		return $this->_moRoom;
	}
	public function room_get($iGameId) {
		return $this->_moRoom->get($iGameId);
	}
	public function client_get($iMatchId, $iSlotId) {
		$oMatch = $this->game_get($iMatchId);
		if($oMatch === null) {
			return null;
		}
		return $oMatch->client_get($iSlotId);
	}
	public function gameList_get() {
		return $this->_moRoom;
	}
	public function gameInput_get($iGameId) {
		return $this->_moGameInput->get($iGameId);
	}
	public function game_create() {
		$oRoom = new mygame_server_model_Room(new mygame_game_MyGame());
		$this->_moRoom->set(mygame_server_model_RoomManager::$_iIdAutoIncrement, $oRoom);
		mygame_server_model_RoomManager::$_iIdAutoIncrement++;
		$oRoom->onUpdate->attach($this->onAnyRoomUpdate);
	}
	public function game_process() {
		if(null == $this->_moRoom) throw new HException('null iterable');
		$__hx__it = $this->_moRoom->iterator();
		while($__hx__it->hasNext()) {
			unset($oRoom);
			$oRoom = $__hx__it->next();
			if($oRoom->timerExpire_check() && !$oRoom->paused_get()) {
				$this->onAnyProcessStart->dispatch($oRoom);
				$oRoom->process();
			}
		}
	}
	public function gameInput_add($iGameId, $oPlayerInput) {
		$oGame = $this->game_get_byId($iGameId);
		if($oGame === null) {
			throw new HException("Game doesnt exist ");
			return;
		}
		$oGameInput = $this->_moGameInput->get($iGameId);
		if($oGameInput === null) {
			$oGameInput = new mygame_connection_GameInput();
			$this->_moGameInput->set($iGameId, $oGameInput);
		} else {
			$oGameInput->aoPlayerInput->push($oPlayerInput);
		}
	}
	public function game_get_byId($iKey) {
		return $this->_moRoom->get($iKey);
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
	static $_iIdAutoIncrement = 0;
	function __toString() { return 'mygame.server.model.RoomManager'; }
}
