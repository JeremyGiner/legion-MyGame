package mygame.game.entity;
import legion.entity.Entity;
import mygame.game.ability.LoyaltyShifter;
import mygame.game.entity.PlatoonUnit;
import mygame.game.MyGame;
import space.Vector2i;
import space.Vector3 in Vector2;
import mygame.game.ability.Weapon;
import mygame.game.ability.Health;
import mygame.game.ability.Guidance;
import mygame.game.ability.Mobility;
import mygame.game.ability.PositionPlan;
import mygame.game.misc.weapon.WeaponTypeSoldier;

/**
 * ...
 * @author GINER Jérémy
 */
class SubUnit extends Unit {

	var _oPlatoon :Unit;
	
	public function new( oParent :Unit, oPosition :Vector2i ) {
		_oPlatoon = oParent;
		
		var oGame :MyGame =  cast _oPlatoon.game_get();
		super( 
			oGame, 
			_oPlatoon.owner_get(),
			oPosition
		);
		
		_ability_add( new Health( this ) );
		_ability_add( new PositionPlan( this, 2 ) );
		_ability_add( new Mobility( this, 1000 ) );
		_ability_add( new Guidance( this ) );
		_ability_add( new Weapon( this, oGame.singleton_get( WeaponTypeSoldier ) ) );
		_ability_add( new LoyaltyShifter( this ) );
	
	}
	
	
	public function platoon_get() {
		return _oPlatoon;
	}
}