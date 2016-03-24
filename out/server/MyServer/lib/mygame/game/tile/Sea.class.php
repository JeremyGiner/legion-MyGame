<?php

class mygame_game_tile_Sea extends mygame_game_tile_Tile {
	public function __construct($oMap, $x, $y) { if(!php_Boot::$skip_constructor) {
		parent::__construct($oMap,$x,$y,0,0);
		$this->_z = 0;
	}}
	function __toString() { return 'mygame.game.tile.Sea'; }
}
