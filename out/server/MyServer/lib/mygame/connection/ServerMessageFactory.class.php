<?php

class mygame_connection_ServerMessageFactory {
	public function __construct() {}
	static function resGameJoin_create($oRoom, $iSlotId) { if(!php_Boot::$skip_constructor) {
		$o = new mygame_connection_message_ResGameJoin();
		$o->iGameId = $oRoom->id_get();
		$o->iSlotId = $iSlotId;
		$o->oGame = $oRoom->game_get();
		$o->oRoomUpdate = mygame_connection_ServerMessageFactory::roomUpdate_create($oRoom);
		return $o;
	}}
	static function roomUpdate_create($oRoom) {
		$oRoomUpdate = new mygame_connection_message_serversent_RoomUpdate();
		$oRoomUpdate->aUser = new _hx_array(array());
		$aPause = $oRoom->pauseList_get();
		{
			$_g1 = 0;
			$_g = $aPause->length;
			while($_g1 < $_g) {
				$i = $_g1++;
				$oRoomUpdate->aUser[$i] = _hx_anonymous(array("name" => "player" . _hx_string_rec($i, ""), "ready" => $aPause[$i], "ai" => false, "playerId" => $i));
				unset($i);
			}
		}
		$oRoomUpdate->iGameSpeed = Std::int($oRoom->gameSpeed_get());
		return $oRoomUpdate;
	}
	function __toString() { return 'mygame.connection.ServerMessageFactory'; }
}
