<?php

class websocket_SocketLocal extends websocket_Socket {
	public function __construct($oResource) { if(!php_Boot::$skip_constructor) {
		parent::__construct($oResource);
	}}
	public function accept() {
		$oResource = @socket_accept($this->_oResource);
		if(_hx_equal($oResource, false)) {
			return null;
		}
		return $oResource;
	}
	public function bind($sHost = null, $iPort = null) {
		if($iPort === null) {
			$iPort = 8000;
		}
		if($sHost === null) {
			$sHost = "127.0.0.1";
		}
		socket_bind($this->_oResource, $sHost, $iPort);
	}
	public function listen($iBacklog = null) {
		if($iBacklog === null) {
			$iBacklog = 0;
		}
		socket_listen($this->_oResource, $iBacklog);
	}
	public function write($sBuffer) {
		return socket_write($this->_oResource, $sBuffer, strlen($sBuffer));
	}
	static function create() {
		return new websocket_SocketLocal(socket_create( AF_INET, SOCK_STREAM, SOL_TCP ));
	}
	function __toString() { return 'websocket.SocketLocal'; }
}
