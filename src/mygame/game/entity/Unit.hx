package mygame.game.entity;


import legion.entity.Entity;
import mygame.game.ability.Loyalty;
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
		
		_ability_add( 
			new Loyalty( this, oOwner ) 
		);
		
	}
	
//______________________________________________________________________________
//	Accessor

	/*
	 * DEPRECATED
	 */
	public function owner_get() { return ability_get(Loyalty).owner_get(); }

	public function mygame_get() {
		return cast( _oGame, MyGame );
	}
}
