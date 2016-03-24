<?php

class mygame_serverRemote_server_Server {
	public function __construct(){}
	static function main() {
		$oController = new mygame_serverRemote_server_controller_Controller(php_Web::getParams());
	}
	function __toString() { return 'mygame.serverRemote.server.Server'; }
}
