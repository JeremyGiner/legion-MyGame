package mygame.game.utils.validatorentity;
import legion.entity.Entity;
import legion.entity.Player;
import mygame.game.ability.Loyalty;
import mygame.game.utils.IValidatorEntity;

/**
 * ...
 * @author GINER Jérémy
 */
class ValiAlliance implements IValidatorEntity {

	var _oPlayer :Player;
	
	public function new( oPlayer :Player ) {
		_oPlayer = oPlayer;
	}
	
	public function validate( oEntity :Entity ) {
		return oEntity.ability_get(Loyalty).owner_get() == _oPlayer;
	}
}