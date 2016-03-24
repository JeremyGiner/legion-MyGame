package mygame.game.entity;

import mygame.game.ability.LoyaltyShifter;
import mygame.game.misc.weapon.WeaponTypeBazoo;
import mygame.game.MyGame in Game;
import mygame.game.entity.Player;
import space.Vector2i;

import mygame.game.tile.Tile;

import space.Vector3 in Vector2;

import mygame.game.entity.Unit;
import mygame.game.ability.*;

class Copter extends Unit {

	
//______________________________________________________________________________
//	Constructor

	public function new( oGame :Game, oPlayer :Player, oPosition :Vector2i ){
		super( oGame, oPlayer, oPosition );
		
		_ability_add( new PositionPlan( this, 0 ) );
		_ability_add( new Mobility( this, 0.05 ) );
		_ability_add( new Volume( this, 0.1 ) );
		_ability_add( new Guidance( this ) );
		_ability_add( new Weapon( this, oGame.singleton_get( WeaponTypeBazoo ) ) );
		_ability_add( new Health( this ) );
		_ability_add( new LoyaltyShifter( this ) );
		
		this.ability_get( Mobility ).orientationSpeed_set( 0.05 );
	}

//______________________________________________________________________________
//	Accessor
	

}