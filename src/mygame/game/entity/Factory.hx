package mygame.game.entity;

import mygame.game.MyGame;

import mygame.game.entity.Player;

import mygame.game.entity.Building;
import mygame.game.tile.Tile;

import mygame.game.ability.BuilderFactory;

class Factory extends Building {
	
	public function new( oGame :MyGame, oPlayer :Player,oTile :Tile ){
		super( oGame, oPlayer, oTile );
		
		_ability_add( new BuilderFactory( this ) );
	}
}