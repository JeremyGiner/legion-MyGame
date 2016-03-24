package mygame.game.entity;

import mygame.game.entity.Player;
import space.Vector2i;

import mygame.game.ability.Position;
import space.Vector3 in Vector2;
import mygame.game.tile.Tile;

class Building extends Unit {
	
	function new( oGame :MyGame, oPlayer :Player, oTile :Tile ){
		super( 
			oGame, 
			oPlayer, 
			new Vector2i( oTile.x_get()*10000+5000, oTile.y_get()*10000+5000 ) 
		);
	}
}