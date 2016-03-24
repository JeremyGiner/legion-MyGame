package mygame.game.tile;

import mygame.game.entity.WorldMap;

class Sea extends Tile {
	
	public function new( oMap :WorldMap, x :Int, y :Int ){
		super( oMap, x, y, 0, 0 );
		_z = 0;
	}

}