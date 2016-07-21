package mygame.game.entity;

import mygame.game.ability.LoyaltyShifter;
import mygame.game.ability.PositionPlan;
import mygame.game.misc.weapon.WeaponTypeBazoo;
import mygame.game.MyGame in Game;
import mygame.game.entity.Player;
import space.Vector2i;

import mygame.game.tile.Tile;

import space.Vector3 in Vector2;

import mygame.game.ability.*;

/**
 * @author GINER Jérémy
 */
class Bazoo extends SubUnit {

	
//______________________________________________________________________________
//	Constructor

	public function new( oGame :Game, oPlayer :Player, oPosition :Vector2i, oPlatoon :Platoon = null ){
		super( oGame, oPlayer, oPosition, oPlatoon );
		
		_ability_add( new PositionPlan( this, 2 ) );
		_ability_add( new Mobility( this, 200 ) );
		_ability_add( new Guidance( this ) );
		_ability_add( new Weapon( this, oGame.singleton_get( WeaponTypeBazoo ) ) );
		_ability_add( new Health( this ) );
		_ability_add( new LoyaltyShifter( this ) );
	}

//______________________________________________________________________________
//	Accessor
	

}