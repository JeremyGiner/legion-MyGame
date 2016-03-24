<?php

class mygame_server_controller_Controller implements trigger_ITrigger{
	public function __construct($oModel) {
		if(!php_Boot::$skip_constructor) {
		$this->_oModel = $oModel;
		$this->_oRoomManager = new mygame_server_model_RoomManager();
		$this->_oRoomManager->game_create();
		$this->_oRoomManager->game_create();
		$this->_oRoomManager->game_create();
		$this->_oServer = new websocket_php_Server("localhost", 8000, new mygame_server_misc_ClientFactory());
		$this->_oServer->start();
		$this->_oServer->onAnyOpen->attach($this);
		$this->_oClientController = new mygame_server_controller_ClientController($this, $this->_oRoomManager);
		$this->run();
	}}
	public $_oModel;
	public $_oClientController;
	public $_oRoomManager;
	public $_oServer;
	public function server_get() {
		return $this->_oServer;
	}
	public function run() {
		while(true) {
			$this->_oServer->socket_process();
			$this->_oRoomManager->game_process();
		}
		haxe_Log::trace("server terminated", _hx_anonymous(array("fileName" => "Controller.hx", "lineNumber" => 72, "className" => "mygame.server.controller.Controller", "methodName" => "run")));
	}
	public function trigger($oSource) {
		if($oSource === $this->_oServer->onAnyOpen) {
			haxe_Log::trace("[NOTICE]:New client.", _hx_anonymous(array("fileName" => "Controller.hx", "lineNumber" => 82, "className" => "mygame.server.controller.Controller", "methodName" => "trigger")));
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
	function __toString() { return 'mygame.server.controller.Controller'; }
}
