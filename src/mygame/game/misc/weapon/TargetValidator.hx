package mygame.game.misc.weapon;
import legion.entity.Entity;
import mygame.game.ability.Weapon;
import mygame.game.utils.IValidatorEntity;

/**
 * ...
 * @author GINER Jérémy
 */
class TargetValidator implements IValidatorEntity {
	
	var _oWeapon :Weapon;
	
	public function new( oWeapon :Weapon ) {
		_oWeapon = oWeapon;
	}
	
	public function validate( oEntity :Entity ) {
		return _oWeapon.type_get().target_check( _oWeapon, oEntity );
	}
	
}