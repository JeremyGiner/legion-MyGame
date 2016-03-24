<?php

class mygame_server_misc_ClientFactory extends websocket_SocketDistantFactory {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		parent::__construct();
	}}
	public function create() {
		return new mygame_server_model_Client($this->_oResource);
	}
	function __toString() { return 'mygame.server.misc.ClientFactory'; }
}
