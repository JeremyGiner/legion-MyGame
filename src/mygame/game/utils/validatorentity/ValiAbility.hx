package mygame.game.utils.validatorentity;
import legion.ability.IAbility;
import legion.entity.Entity;
import legion.entity.Player;
import mygame.game.ability.Loyalty;
import mygame.game.utils.IValidatorEntity;

/**
 * ...
 * @author GINER Jérémy
 */
class ValiAbility implements IValidatorEntity {

	var _sClassName :String;
	
	public function new( oClass :Class<IAbility> ) {
		_sClassName = Type.getClassName( oClass );
	}
	
	public function validate( oEntity :Entity ) {
		return oEntity.abilityMap_get().get(_sClassName) != null;
	}
}