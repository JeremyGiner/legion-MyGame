<?php

class mygame_server_MyServer {
	public function __construct(){}
	static function main() {
		$oModel = new mygame_server_model_Model();
		$oController = new mygame_server_controller_Controller($oModel);
	}
	function __toString() { return 'mygame.server.MyServer'; }
}
