package mygame.game.entity;


import legion.entity.Entity;
import space.Vector2i;

import mygame.game.MyGame in Game;
import mygame.game.entity.Player;
import mygame.game.tile.Tile;

import space.Vector3 in Vector2;

import mygame.game.ability.Health;

import mygame.game.ability.Mobility;
import mygame.game.ability.Position;

import legion.ability.IAbility;
import haxe.ds.StringMap;

class Unit extends Entity {

	var _oPlayer :Player;

//______________________________________________________________________________
//	Constructor

	function new( oGame :Game, oOwner :Player, oPosition :Vector2i ) {
		super( oGame );
		
		_oPlayer = oOwner;
		
		_ability_add( 
			new Position( this, oGame.map_get(), oPosition.x, oPosition.y ) 
		);
		
	}
	
//______________________________________________________________________________
//	Accessor

	public function owner_get() { return _oPlayer; }
	public function owner_set( oPlayer :Player ) { 
		onUpdate.dispatch( this );
		_oPlayer = oPlayer;
	}

	public function mygame_get() {
		return cast( _oGame, MyGame );
	}
}
