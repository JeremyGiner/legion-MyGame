<?php

class mygame_game_tile_Forest extends mygame_game_tile_Tile {
	public function __construct($oMap, $x, $y) { if(!php_Boot::$skip_constructor) {
		parent::__construct($oMap,$x,$y,2,2);
	}}
	function __toString() { return 'mygame.game.tile.Forest'; }
}
