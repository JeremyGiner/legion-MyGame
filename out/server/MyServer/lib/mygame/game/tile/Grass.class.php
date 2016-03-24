<?php

class mygame_game_tile_Grass extends mygame_game_tile_Tile {
	public function __construct($oMap, $x, $y) { if(!php_Boot::$skip_constructor) {
		parent::__construct($oMap,$x,$y,2,1);
	}}
	function __toString() { return 'mygame.game.tile.Grass'; }
}
