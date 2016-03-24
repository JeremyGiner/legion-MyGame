<?php

class websocket_php_Socket {
	public function __construct($oResource) {
		if(!php_Boot::$skip_constructor) {
		$this->_oResource = $oResource;
		$this->_bClosed = false;
		$this->onClose = new trigger_eventdispatcher_EventDispatcher();
		socket_set_nonblock($this->_oResource);
	}}
	public $_oResource;
	public $_bClosed;
	public $onClose;
	public function resource_get() {
		return $this->_oResource;
	}
	public function closed_check() {
		return $this->_bClosed;
	}
	public function close() {
		socket_close($this->_oResource);
		$this->_close();
	}
	public function errorLast_get() {
		$iErrorCode = socket_last_error($this->_oResource);
		return socket_strerror($iErrorCode);
	}
	public function _close() {
		$this->_bClosed = true;
		$this->onClose->dispatch($this);
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
	function __toString() { return 'websocket.php.Socket'; }
}
