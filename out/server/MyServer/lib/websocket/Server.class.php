<?php

class websocket_Server {
	public function __construct($sHost = null, $iPort = null) {
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
	}}
	public $_sHost;
	public $_iPort;
	public $_bRunning;
	public function running_check() {
		return $this->_bRunning;
	}
	public function start() {
		$this->_bRunning = true;
	}
	public function stop() {
		$this->_bRunning = false;
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
