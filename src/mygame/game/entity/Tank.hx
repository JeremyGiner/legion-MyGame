package mygame.game.entity;


import math.Limit;
import mygame.game.entity.Player;
import mygame.game.misc.weapon.WeaponTypeBazoo;
import mygame.game.MyGame in Game;
import space.Vector2i;

import mygame.game.tile.Tile;

import space.Vector3 in Vector2;


import mygame.game.entity.Unit;
import mygame.game.ability.*;

/**
 * @author GINER Jérémy
 */
class Tank extends Unit {

//______________________________________________________________________________
//	Constructor

	public function new( oGame :Game, oPlayer :Player, oPosition :Vector2i ){
		super( oGame, oPlayer, oPosition );
		
		_ability_add( new PositionPlan( this, 1 ) );
		_ability_add( new Volume( this, 2000, 0.45 ) );
		_ability_add( new Mobility( this, 200 ) );
		_ability_add( new Guidance( this ) );	//May require volume
		_ability_add( new Weapon( this, oGame.singleton_get( WeaponTypeBazoo ) ) );
		_ability_add( new Health( this, true ) );
	}

//______________________________________________________________________________
//	Accessor
	
	//public function mobility_get() { return cast trait_get( TraitMobility ); }
	
//______________________________________________________________________________
//	Shortcut


}