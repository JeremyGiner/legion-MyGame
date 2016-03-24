<?php

class mygame_connection_message_ReqGameQuit implements mygame_connection_message_ILobbyMessage{
	public function __construct() {}
	function __toString() { return 'mygame.connection.message.ReqGameQuit'; }
}
