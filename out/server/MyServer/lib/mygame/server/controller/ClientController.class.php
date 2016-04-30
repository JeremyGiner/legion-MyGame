<?php

class mygame_server_controller_ClientController implements trigger_ITrigger{
	public function __construct($oParent, $oRoomManager) {
		if(!php_Boot::$skip_constructor) {
		$this->_oParent = $oParent;
		$this->_oRoomManager = $oRoomManager;
		$this->_oParent->server_get()->onAnyMessage->attach($this);
		$this->_oParent->server_get()->onAnyClose->attach($this);
		$this->_oRoomManager->onAnyProcessStart->attach($this);
		$this->_oRoomManager->onAnyRoomUpdate->attach($this);
	}}
	public $_oRoomManager;
	public $_oParent;
	public function message_handle($oClient) {
		$oMessage = $oClient->messageLast_get();
		{
			$_g = Type::getClass($oMessage);
			switch($_g) {
			case _hx_qtype("mygame.connection.message.ReqSlotList"):{
				haxe_Log::trace("requesting game list", _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 42, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
				$oRespond = new mygame_connection_message_ResSlotList();
				if(null == $this->_oRoomManager->gameList_get()) throw new HException('null iterable');
				$__hx__it = $this->_oRoomManager->gameList_get()->keys();
				while($__hx__it->hasNext()) {
					unset($iKey);
					$iKey = $__hx__it->next();
					$oRespond->liGameId->push($iKey);
				}
				$oClient->send($oRespond);
			}break;
			case _hx_qtype("mygame.connection.message.ReqShutDown"):{
				haxe_Log::trace("Closing by command of a client", _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 56, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
				Sys::hexit(0);
			}break;
			case _hx_qtype("mygame.connection.message.ReqGameJoin"):{
				haxe_Log::trace("[NOTICE]:requesting access to game #" . _hx_string_rec(_hx_deref(($oMessage))->gameId_get(), ""), _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 61, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
				$iRoomId = _hx_deref(($oMessage))->gameId_get();
				$iSlotId = _hx_deref(($oMessage))->slotId_get();
				if($oClient->room_get() !== null) {
					$oClient->room_get()->slot_leave($oClient);
				}
				$oRoom = $this->_oRoomManager->room_get($iRoomId);
				if($oRoom === null) {
					haxe_Log::trace("[ERROR]:Room #" . _hx_string_rec($iRoomId, "") . " does not exist.", _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 73, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
					return;
				}
				if($iSlotId === -1) {
					$iSlotId = $oRoom->slotFreeAny_get();
				}
				if($iSlotId === null) {
					throw new HException("slot :not any available");
				}
				$iSlotAvailable = $oRoom->slot_occupy($oClient, $iSlotId);
				if($iSlotAvailable === null) {
					haxe_Log::trace("[ERROR]:slot occupation fail.", _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 84, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
					return;
				}
				haxe_Log::trace("Occupied slot #" . _hx_string_rec($iSlotAvailable, ""), _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 88, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
				haxe_Log::trace("Room client Q = " . _hx_string_rec($oRoom->clientList_get()->length, ""), _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 89, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
				$oRespond1 = mygame_connection_ServerMessageFactory::resGameJoin_create($oRoom, $iSlotAvailable);
				haxe_Log::trace($oRespond1, _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 93, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
				$oClient->send($oRespond1);
				$oRoomUpdate = $oRespond1->oRoomUpdate;
				if(null == $oRoom->clientList_get()) throw new HException('null iterable');
				$__hx__it = $oRoom->clientList_get()->iterator();
				while($__hx__it->hasNext()) {
					unset($oClientTmp);
					$oClientTmp = $__hx__it->next();
					if($oClient !== $oClientTmp) {
						$oClientTmp->send($oRoomUpdate);
					}
				}
			}break;
			case _hx_qtype("mygame.connection.message.ReqPlayerInput"):{
				if($oClient->room_get() === null) {
					haxe_Log::trace("[ERROR]: input send to no room", _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 106, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
					return;
				}
				$oClient->room_get()->gameAction_add(_hx_deref(($oMessage))->action_get($oClient->player_get()));
			}break;
			case _hx_qtype("mygame.connection.message.ReqGameQuit"):{
				if($oClient->room_get() === null) {
					haxe_Log::trace("[ERROR] : Client trying to leave a null room", _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 120, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
					return;
				}
				$oClient->room_get()->slot_leave($oClient);
				$oClient->room_set(null, -1);
			}break;
			case _hx_qtype("mygame.connection.message.clientsent.ReqReadyUpdate"):{
				$oRoom1 = $oClient->room_get();
				if($oRoom1 === null) {
					$oClient->send(new mygame_connection_message_serversent_ResError(1, "Trying to update ready status while not in room"));
				}
				$oRoom1->clientReady_update($oClient, _hx_deref(($oMessage))->ready_get());
			}break;
			default:{
				haxe_Log::trace("[ERROR]:unknow command/respond from client:" . Std::string($oMessage), _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 141, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
			}break;
			}
		}
	}
	public function trigger($oSource) {
		if($oSource === $this->_oParent->server_get()->onAnyClose) {
			$oClient = $oSource->event_get();
			$oRoom = $oClient->room_get();
			if($oRoom === null) {
				return;
			}
			$oRoom->slot_leave($oClient);
			if(null == $oRoom->clientList_get()) throw new HException('null iterable');
			$__hx__it = $oRoom->clientList_get()->iterator();
			while($__hx__it->hasNext()) {
				unset($oClient1);
				$oClient1 = $__hx__it->next();
				$oClient1->send(mygame_connection_ServerMessageFactory::roomUpdate_create($oRoom));
			}
		}
		if($oSource === $this->_oParent->server_get()->onAnyMessage) {
			$this->message_handle($oSource->event_get());
		}
		if($oSource === $this->_oRoomManager->onAnyProcessStart) {
			$oRoom1 = $oSource->event_get();
			$oMessage = new mygame_connection_message_ResGameStepInput($oRoom1->game_get()->loopId_get(), $oRoom1->gameActionList_get());
			if(null == $oRoom1->clientList_get()) throw new HException('null iterable');
			$__hx__it = $oRoom1->clientList_get()->iterator();
			while($__hx__it->hasNext()) {
				unset($oClient2);
				$oClient2 = $__hx__it->next();
				$oClient2->send($oMessage);
			}
		}
		if($oSource === $this->_oRoomManager->onAnyRoomUpdate) {
			$oRoom2 = $this->_oRoomManager->onAnyRoomUpdate->event_get();
			$oMessage1 = mygame_connection_ServerMessageFactory::roomUpdate_create($oRoom2);
			if(null == $oRoom2->clientList_get()) throw new HException('null iterable');
			$__hx__it = $oRoom2->clientList_get()->iterator();
			while($__hx__it->hasNext()) {
				unset($oClient3);
				$oClient3 = $__hx__it->next();
				$oClient3->send($oMessage1);
			}
		}
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
	function __toString() { return 'mygame.server.controller.ClientController'; }
}
