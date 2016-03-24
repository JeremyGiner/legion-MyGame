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
				haxe_Log::trace("requesting game list", _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 41, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
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
				haxe_Log::trace("Closing by command of a client", _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 55, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
				Sys::hexit(0);
			}break;
			case _hx_qtype("mygame.connection.message.ReqGameJoin"):{
				haxe_Log::trace("[NOTICE]:requesting access to game #" . _hx_string_rec(_hx_deref(($oMessage))->gameId_get(), ""), _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 60, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
				$iRoomId = _hx_deref(($oMessage))->gameId_get();
				$iSlotId = _hx_deref(($oMessage))->slotId_get();
				if($oClient->room_get() !== null) {
					$oClient->room_get()->slot_leave($oClient);
				}
				$oRoom = $this->_oRoomManager->room_get($iRoomId);
				if($oRoom === null) {
					haxe_Log::trace("[ERROR]:Room #" . _hx_string_rec($iRoomId, "") . " does not exist.", _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 72, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
					return;
				}
				if($iSlotId === -1) {
					$iSlotId = $oRoom->slotFreeAny_get();
				}
				if($iSlotId === null) {
					throw new HException("slot not any free");
				}
				$iSlotAvailable = $oRoom->slot_occupy($oClient, $iSlotId);
				if($iSlotAvailable === null) {
					haxe_Log::trace("[ERROR]:slot occupation fail.", _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 83, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
					return;
				}
				haxe_Log::trace("Occupied slot #" . _hx_string_rec($iSlotAvailable, ""), _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 87, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
				haxe_Log::trace("Room client Q = " . _hx_string_rec($oRoom->clientList_get()->length, ""), _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 88, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
				$o = new mygame_connection_message_ResGameJoin($oRoom->gameSpeed_get());
				$o->iGameId = $iRoomId;
				$o->iSlotId = $iSlotAvailable;
				$o->oGame = $oRoom->game_get();
				$oRespond1 = new websocket_MessageComposite((new _hx_array(array($o, new mygame_connection_message_serversent_RoomStatus($oRoom)))));
				$oClient->send($oRespond1);
				if(null == $oRoom->clientList_get()) throw new HException('null iterable');
				$__hx__it = $oRoom->clientList_get()->iterator();
				while($__hx__it->hasNext()) {
					unset($oClient1);
					$oClient1 = $__hx__it->next();
					$oClient1->send(new mygame_connection_message_serversent_RoomStatus($oRoom));
				}
			}break;
			case _hx_qtype("mygame.connection.message.ReqPlayerInput"):{
				if($oClient->room_get() === null) {
					haxe_Log::trace("[ERROR]: input send to no room", _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 111, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
					return;
				}
				$oClient->room_get()->gameAction_add(_hx_deref(($oMessage))->action_get($oClient->player_get()));
			}break;
			case _hx_qtype("mygame.connection.message.ReqGameQuit"):{
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
				haxe_Log::trace("[ERROR]:unknow command/respond from client:" . Std::string($oMessage), _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 140, "className" => "mygame.server.controller.ClientController", "methodName" => "message_handle")));
			}break;
			}
		}
	}
	public function trigger($oSource) {
		if($oSource === $this->_oRoomManager->onAnyRoomUpdate) {
			$oRoom = $this->_oRoomManager->onAnyRoomUpdate->event_get();
			$oMessage = new mygame_connection_message_serversent_RoomStatus($oRoom);
			if(null == $oRoom->clientList_get()) throw new HException('null iterable');
			$__hx__it = $oRoom->clientList_get()->iterator();
			while($__hx__it->hasNext()) {
				unset($oClient);
				$oClient = $__hx__it->next();
				$oClient->send($oMessage);
			}
		}
		if($oSource === $this->_oParent->server_get()->onAnyClose) {
			$oClient1 = $oSource->event_get();
			$oRoom1 = $oClient1->room_get();
			if($oRoom1 !== null) {
				$oRoom1->slot_leave($oClient1);
				if(null == $oRoom1->clientList_get()) throw new HException('null iterable');
				$__hx__it = $oRoom1->clientList_get()->iterator();
				while($__hx__it->hasNext()) {
					unset($oClient2);
					$oClient2 = $__hx__it->next();
					$oClient2->send(new mygame_connection_message_serversent_RoomStatus($oRoom1));
				}
			}
		}
		if($oSource === $this->_oParent->server_get()->onAnyMessage) {
			$this->message_handle($oSource->event_get());
		}
		if($oSource === $this->_oRoomManager->onAnyProcessStart) {
			$oRoom2 = $oSource->event_get();
			$oMessage1 = new mygame_connection_message_ResGameStepInput($oRoom2->game_get()->loopId_get(), $oRoom2->gameActionList_get());
			if(null == $oRoom2->clientList_get()) throw new HException('null iterable');
			$__hx__it = $oRoom2->clientList_get()->iterator();
			while($__hx__it->hasNext()) {
				unset($oClient3);
				$oClient3 = $__hx__it->next();
				haxe_Log::trace("[NOTICE]:Game input send.", _hx_anonymous(array("fileName" => "ClientController.hx", "lineNumber" => 190, "className" => "mygame.server.controller.ClientController", "methodName" => "trigger")));
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
