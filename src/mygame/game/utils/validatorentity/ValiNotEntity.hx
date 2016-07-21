package mygame.game.utils.validatorentity;
import legion.entity.Entity;
import legion.entity.Player;
import mygame.game.ability.Loyalty;
import mygame.game.utils.IValidatorEntity;

/**
 * ...
 * @author GINER Jérémy
 */
class ValiNotEntity implements IValidatorEntity {

	var _oReference :Entity;
	
	public function new( oEntity :Entity ) {
		_oReference = oEntity;
	}
	
	public function validate( oEntity :Entity ) {
		return oEntity != _oReference;
	}
}