<?php

class websocket_Server {
	public function __construct($sHost = null, $iPort = null, $oSocketFactory = null) {
		if(!php_Boot::$skip_constructor) {
		if($iPort === null) {
			$iPort = 8000;
		}
		if($sHost === null) {
			$sHost = "localhost";
		}
		$this->_sHost = $sHost;
		$this->_iPort = $iPort;
		$this->_bRunning = false;
		if($oSocketFactory !== null) {
			$this->_oSocketFactory = $oSocketFactory;
		} else {
			$this->_oSocketFactory = new websocket_SocketDistantFactory();
		}
		$this->_aSocketDistant = new HList();
		$this->onAnyOpen = new trigger_EventDispatcher2();
		$this->onAnyMessage = new trigger_eventdispatcher_EventDispatcherFunel();
		$this->onAnyClose = new trigger_eventdispatcher_EventDispatcherFunel();
	}}
	public $_bRunning;
	public $_sHost;
	public $_iPort;
	public $_oSocketMaster;
	public $_oSocketFactory;
	public $_aSocketDistant;
	public $onAnyOpen;
	public $onAnyMessage;
	public $onAnyClose;
	public function running_check() {
		return $this->_bRunning;
	}
	public function start() {
		$this->_bRunning = true;
		$this->_oSocketMaster = websocket_SocketLocal::create();
		$this->_oSocketMaster->bind($this->_sHost, $this->_iPort);
		$this->_oSocketMaster->listen(null);
	}
	public function socket_process() {
		if(!$this->_bRunning) {
			throw new HException("[ERROR] Server : Server not started yet");
		}
		$this->_socketAccept_process();
		$this->_socketMessage_process();
	}
	public function _socketAccept_process() {
		$oResource = $this->_oSocketMaster->accept();
		if($oResource === null) {
			return;
		}
		$oSocketDistant = $this->_oSocketFactory->resource_set($oResource)->create();
		$this->_aSocketDistant->push($oSocketDistant);
		$oSocketDistant->onMessage->attach($this->onAnyMessage);
		$oSocketDistant->onClose->attach($this->onAnyClose);
		haxe_Log::trace("[NOTICE] Server : new distant socket (#" . Std::string($oSocketDistant->resource_get()) . ").", _hx_anonymous(array("fileName" => "Server.hx", "lineNumber" => 102, "className" => "websocket.Server", "methodName" => "_socketAccept_process")));
		haxe_Log::trace($oSocketDistant, _hx_anonymous(array("fileName" => "Server.hx", "lineNumber" => 103, "className" => "websocket.Server", "methodName" => "_socketAccept_process")));
		$this->onAnyOpen->dispatch($oSocketDistant);
	}
	public function _socketMessage_process() {
		$aSocketDistantActive = new HList();
		if(null == $this->_aSocketDistant) throw new HException('null iterable');
		$__hx__it = $this->_aSocketDistant->iterator();
		while($__hx__it->hasNext()) {
			unset($oSocketDistant);
			$oSocketDistant = $__hx__it->next();
			if($oSocketDistant->closed_check() !== false) {
				continue;
			}
			$oSocketDistant->process();
			if($oSocketDistant->closed_check() !== false) {
				continue;
			}
			$aSocketDistantActive->push($oSocketDistant);
		}
		$this->_aSocketDistant = $aSocketDistantActive;
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
	function __toString() { return 'websocket.Server'; }
}
