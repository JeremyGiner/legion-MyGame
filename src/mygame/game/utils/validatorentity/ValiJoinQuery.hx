package mygame.game.utils.validatorentity;
import legion.ability.IAbility;
import legion.entity.Entity;
import legion.entity.Player;
import mygame.game.ability.Loyalty;
import mygame.game.query.EntityQueryAdv;
import mygame.game.utils.IValidatorEntity;

/**
 * ...
 * @author GINER Jérémy
 */
class ValiAbility implements IValidatorEntity {

	var _oQuery :EntityQueryAdv;
	
	public function new( oQuery :EntityQueryAdv ) {
		_oQuery = oQuery;
	}
	
	public function validate( oEntity :Entity ) {
		return _oQuery.data_get().exists( oEntity.identity_get() );
	}
}