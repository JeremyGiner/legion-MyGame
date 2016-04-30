<?php

class websocket_SocketDistantFactory {
	public function __construct() {}
	public $_oResource;
	public function resource_set($oResource) {
		if(!php_Boot::$skip_constructor) {
		$this->_oResource = $oResource;
		return $this;
	}}
	public function create() {
		return new websocket_SocketDistant($this->_oResource);
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
	function __toString() { return 'websocket.SocketDistantFactory'; }
}
