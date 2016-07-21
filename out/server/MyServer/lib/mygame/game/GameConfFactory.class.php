<?php

class mygame_game_GameConfFactory {
	public function __construct(){}
	static function gameConfDefault_get() {
		return _hx_anonymous(array("playerArr" => (new _hx_array(array(_hx_anonymous(array("name" => "Player 0 (blue)", "roster" => (new _hx_array(array("mygame.game.entity.Soldier", "mygame.game.entity.Bazoo", "mygame.game.entity.Tank"))))), _hx_anonymous(array("name" => "Player 1 (yellow)", "roster" => (new _hx_array(array("mygame.game.entity.Soldier", "mygame.game.entity.Bazoo", "mygame.game.entity.Tank")))))))), "map" => _hx_anonymous(array("sizeX" => 15, "sizeY" => 10, "tileArr" => (new _hx_array(array((new _hx_array(array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))), (new _hx_array(array(0, 0, 1, 2, 4, 4, 4, 4, 4, 1, 2, 1, 1, 1, 0))), (new _hx_array(array(0, 1, 1, 2, 4, 2, 0, 1, 4, 1, 1, 1, 1, 1, 0))), (new _hx_array(array(0, 1, 1, 4, 4, 0, 0, 0, 4, 1, 3, 1, 4, 1, 0))), (new _hx_array(array(0, 1, 1, 4, 1, 0, 0, 0, 4, 1, 3, 1, 4, 1, 0))), (new _hx_array(array(0, 1, 4, 4, 1, 0, 0, 2, 4, 4, 4, 4, 4, 1, 0))), (new _hx_array(array(0, 1, 1, 1, 1, 1, 1, 2, 2, 1, 0, 0, 4, 0, 0))), (new _hx_array(array(0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0))), (new _hx_array(array(0, 0, 0, 1, 3, 1, 3, 2, 1, 1, 4, 1, 1, 1, 0))), (new _hx_array(array(0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 4, 0)))))), "unitArr" => (new _hx_array(array())), "modifier" => mygame_game_GameConfMapModifier::$MirrorX))));
	}
	function __toString() { return 'mygame.game.GameConfFactory'; }
}
