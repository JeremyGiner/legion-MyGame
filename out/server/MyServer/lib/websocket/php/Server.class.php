<?php

class websocket_php_Server extends websocket_Server {
	public function __construct($sHost = null, $iPort = null, $oSocketFactory = null) {
		if(!php_Boot::$skip_constructor) {
		if($iPort === null) {
			$iPort = 8000;
		}
		if($sHost === null) {
			$sHost = "localhost";
		}
		parent::__construct($sHost,$iPort);
		if($oSocketFactory === null) {
			$this->_oSocketFactory = new websocket_SocketDistantFactory();
		} else {
			$this->_oSocketFactory = $oSocketFactory;
		}
		$this->_aoSocketDistant = new HList();
		$this->onAnyOpen = new trigger_EventDispatcher2();
		$this->onAnyMessage = new trigger_eventdispatcher_EventDispatcherFunel();
		$this->onAnyClose = new trigger_EventDispatcher2();
	}}
	public $_oSocketMaster;
	public $_oSocketFactory;
	public $_aoSocketDistant;
	public $onAnyOpen;
	public $onAnyMessage;
	public $onAnyClose;
	public function start() {
		$this->_bRunning = true;
		$this->_oSocketMaster = websocket_php_SocketLocal::create();
		$this->_oSocketMaster->bind($this->_sHost, $this->_iPort);
		$this->_oSocketMaster->listen(null);
		haxe_Log::trace("[NOTICE] SERVER : up and running.", _hx_anonymous(array("fileName" => "Server.hx", "lineNumber" => 58, "className" => "websocket.php.Server", "methodName" => "start")));
	}
	public function socket_process() {
		if(!$this->_bRunning) {
			throw new HException("Server not started yet");
		}
		$oResource = $this->_oSocketMaster->accept();
		if($oResource !== null) {
			$oSocketDistant = $this->_oSocketFactory->resource_set($oResource)->create();
			$this->_aoSocketDistant->push($oSocketDistant);
			$oSocketDistant->onMessage->attach($this->onAnyMessage);
			haxe_Log::trace("[NOTICE] SERVER : new distant socket (#" . Std::string($oSocketDistant->resource_get()) . ").", _hx_anonymous(array("fileName" => "Server.hx", "lineNumber" => 89, "className" => "websocket.php.Server", "methodName" => "socket_process")));
		}
		$aoSocketDistantActive = new HList();
		if(null == $this->_aoSocketDistant) throw new HException('null iterable');
		$__hx__it = $this->_aoSocketDistant->iterator();
		while($__hx__it->hasNext()) {
			unset($oSocketDistant1);
			$oSocketDistant1 = $__hx__it->next();
			if($oSocketDistant1->closed_check() === false) {
				$oSocketDistant1->process();
				if($oSocketDistant1->closed_check() === false) {
					$aoSocketDistantActive->push($oSocketDistant1);
				}
			}
		}
		$this->_aoSocketDistant = $aoSocketDistantActive;
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
	function __toString() { return 'websocket.php.Server'; }
}
