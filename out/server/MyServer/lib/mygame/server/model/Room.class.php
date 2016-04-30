<?php

class mygame_server_model_Room {
	public function __construct($iId, $oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_fGamePaceLapse = 45;
		$this->_sPasswordShadow = "";
		$this->_bPlayerSpontaneous = true;
		$this->_iSpectatorMax = 0;
		$this->_iId = $iId;
		$this->_oGame = $oGame;
		$this->_aoSlot = new _hx_array(array());
		$this->_abPause = new _hx_array(array());
		$this->_iSlotQuantityMax = 5;
		{
			$_g1 = 0;
			$_g = $this->_iSlotQuantityMax;
			while($_g1 < $_g) {
				$i = $_g1++;
				$this->_aoSlot[$i] = null;
				unset($i);
			}
		}
		$this->_loAction = new HList();
		$this->onUpdate = new trigger_eventdispatcher_EventDispatcher();
		$this->_oGame->onLoop->attach(new mygame_game_process_MobilityProcess($this->_oGame));
		$this->timer_reset();
	}}
	public $_iId;
	public $_oGame;
	public $_aoSlot;
	public $_iSlotQuantityMax;
	public $_iSpectatorMax;
	public $_bPlayerSpontaneous;
	public $_sPasswordShadow;
	public $_loAction;
	public $_oGamePaceTimer;
	public $_fGamePaceLapse;
	public $_abPause;
	public $onUpdate;
	public function id_get() {
		return $this->_iId;
	}
	public function spectatorMax_get() {
		return $this->_iSpectatorMax;
	}
	public function spectatorMax_set($iSpectatorMax) {
		$this->_iSpectatorMax = $iSpectatorMax;
	}
	public function client_get($iSlotId) {
		return $this->_aoSlot[$iSlotId];
	}
	public function clientList_get() {
		$loClient = new HList();
		{
			$_g = 0;
			$_g1 = $this->_aoSlot;
			while($_g < $_g1->length) {
				$oClient = $_g1[$_g];
				++$_g;
				if($oClient !== null) {
					$loClient->push($oClient);
				}
				unset($oClient);
			}
		}
		return $loClient;
	}
	public function pauseList_get() {
		haxe_Log::trace("Slot:", _hx_anonymous(array("fileName" => "Room.hx", "lineNumber" => 77, "className" => "mygame.server.model.Room", "methodName" => "pauseList_get")));
		haxe_Log::trace($this->_aoSlot, _hx_anonymous(array("fileName" => "Room.hx", "lineNumber" => 78, "className" => "mygame.server.model.Room", "methodName" => "pauseList_get")));
		haxe_Log::trace("Pause:", _hx_anonymous(array("fileName" => "Room.hx", "lineNumber" => 79, "className" => "mygame.server.model.Room", "methodName" => "pauseList_get")));
		haxe_Log::trace($this->_abPause, _hx_anonymous(array("fileName" => "Room.hx", "lineNumber" => 80, "className" => "mygame.server.model.Room", "methodName" => "pauseList_get")));
		return $this->_abPause;
	}
	public function paused_get() {
		if($this->_abPause->length === 0) {
			return true;
		}
		{
			$_g = 0;
			$_g1 = $this->_abPause;
			while($_g < $_g1->length) {
				$bPlayerReady = $_g1[$_g];
				++$_g;
				if(!$bPlayerReady) {
					return true;
				}
				unset($bPlayerReady);
			}
		}
		return false;
	}
	public function slotIndex_get_byClient($oClient) {
		{
			$_g1 = 0;
			$_g = $this->_aoSlot->length;
			while($_g1 < $_g) {
				$i = $_g1++;
				if($this->_aoSlot[$i] === $oClient) {
					return $i;
				}
				unset($i);
			}
		}
		return null;
	}
	public function game_get() {
		return $this->_oGame;
	}
	public function gameActionList_get() {
		return $this->_loAction;
	}
	public function gameSpeed_get() {
		return $this->_fGamePaceLapse;
	}
	public function timerExpire_check() {
		return $this->_oGamePaceTimer < Date::now()->getTime();
	}
	public function clientReady_update($oClient, $bReady) {
		$iSlotIndex = $this->slotIndex_get_byClient($oClient);
		if($iSlotIndex === null) {
			haxe_Log::trace("invalid client for clientReady_update", _hx_anonymous(array("fileName" => "Room.hx", "lineNumber" => 120, "className" => "mygame.server.model.Room", "methodName" => "clientReady_update")));
			return null;
		}
		$this->_abPause[$iSlotIndex] = $bReady;
		$this->onUpdate->dispatch($this);
		return $this;
	}
	public function slot_occupy($oClient, $iSlotId) {
		haxe_Log::trace("occupying #" . _hx_string_rec($iSlotId, ""), _hx_anonymous(array("fileName" => "Room.hx", "lineNumber" => 134, "className" => "mygame.server.model.Room", "methodName" => "slot_occupy")));
		if(!$this->slotIdInRange_check($iSlotId)) {
			throw new HException("slot not in range");
		}
		if($this->slotOccupy_check($iSlotId)) {
			throw new HException("slot #" . _hx_string_rec($iSlotId, "") . " is unavailable :" . Std::string($this->_aoSlot[$iSlotId]));
		}
		$oClient->room_set($this, $iSlotId);
		$this->_aoSlot[$iSlotId] = $oClient;
		$this->_abPause[$iSlotId] = false;
		haxe_Log::trace("create", _hx_anonymous(array("fileName" => "Room.hx", "lineNumber" => 151, "className" => "mygame.server.model.Room", "methodName" => "slot_occupy")));
		haxe_Log::trace($this->_abPause, _hx_anonymous(array("fileName" => "Room.hx", "lineNumber" => 152, "className" => "mygame.server.model.Room", "methodName" => "slot_occupy")));
		return $iSlotId;
	}
	public function slot_leave($oClient) {
		haxe_Log::trace("Client #" . Std::string($oClient->resource_get()) . "leaving slot #" . _hx_string_rec($oClient->slotId_get(), ""), _hx_anonymous(array("fileName" => "Room.hx", "lineNumber" => 158, "className" => "mygame.server.model.Room", "methodName" => "slot_leave")));
		$this->_aoSlot[$oClient->slotId_get()] = null;
		$i = $oClient->slotId_get();
		$this->_abPause->slice($i, $i);
	}
	public function slotOccupy_check($iSlotId) {
		if($this->client_get($iSlotId) === null) {
			return false;
		}
		return true;
	}
	public function slotFreeAny_get() {
		{
			$_g1 = 0;
			$_g = $this->_iSlotQuantityMax;
			while($_g1 < $_g) {
				$i = $_g1++;
				if($this->_aoSlot[$i] === null) {
					return $i;
				}
				unset($i);
			}
		}
		return null;
	}
	public function slotFreeList_get() {
		throw new HException("not implemented yet");
	}
	public function gameAction_add($oAction) {
		$this->_loAction->push($oAction);
	}
	public function process() {
		if(null == $this->_loAction) throw new HException('null iterable');
		$__hx__it = $this->_loAction->iterator();
		while($__hx__it->hasNext()) {
			unset($oInput);
			$oInput = $__hx__it->next();
			$this->_oGame->action_run($oInput);
		}
		$this->_oGame->loop();
		$this->timer_reset();
		$this->_loAction = new HList();
	}
	public function timer_reset() {
		$this->_oGamePaceTimer = Date::now()->getTime() + $this->_fGamePaceLapse;
	}
	public function slotIdInRange_check($iSlotId) {
		if($iSlotId >= 0 && $iSlotId < $this->_iSlotQuantityMax) {
			return true;
		}
		return false;
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
	function __toString() { return 'mygame.server.model.Room'; }
}
