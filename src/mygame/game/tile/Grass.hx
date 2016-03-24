package mygame.game.tile;

import mygame.game.entity.WorldMap;

class Grass extends Tile {
	
	public function new( oMap :WorldMap, x :Int, y :Int ){
		super( oMap, x, y, 2, 1 );
	}

}