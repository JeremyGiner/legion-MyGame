package mygame.game.entity;
import legion.entity.Entity;
import mygame.game.ability.Loyalty;
import mygame.game.ability.LoyaltyShifter;
import mygame.game.ability.Platoon;
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
	
	function new( oGame :MyGame, oPlayer :Player, oPosition :Vector2i, oPlatoon :Platoon = null ) {
		
		super( 
			oGame, 
			oPlayer,
			oPosition
		);
		
		if ( oPlatoon == null ) {
			_ability_add( new Platoon( this ) );
		} else {
			_ability_add( oPlatoon );
		}
	
	}
	
}