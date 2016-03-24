<?php

class mygame_game_entity_Building extends mygame_game_entity_Unit {
	public function __construct($oGame, $oPlayer, $oTile) { if(!php_Boot::$skip_constructor) {
		parent::__construct($oGame,$oPlayer,new space_Vector2i($oTile->x_get() * 10000 + 5000, $oTile->y_get() * 10000 + 5000));
	}}
	function __toString() { return 'mygame.game.entity.Building'; }
}
