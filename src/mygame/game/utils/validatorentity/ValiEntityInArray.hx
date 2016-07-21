package mygame.game.utils.validatorentity;
import legion.entity.Entity;
import legion.entity.Player;
import mygame.game.ability.Loyalty;
import utils.IValidator;

/**
 * ...
 * @author GINER Jérémy
 */
class ValiEntityInArray implements IValidator<Array<Entity>> {

	var _oReference :Entity;
	
	public function new( oEntity :Entity ) {
		_oReference = oEntity;
	}
	
	public function validate( aEntity :Array<Entity> ) {
		for ( oEntity in aEntity )
			if ( oEntity == _oReference )
				return true;
		return false;
	}
}