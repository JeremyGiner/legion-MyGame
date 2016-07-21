package mygame.game.utils.validatorentity;
import legion.ability.IAbility;
import legion.entity.Entity;
import legion.entity.Player;
import mygame.game.ability.Loyalty;
import mygame.game.query.EntityDistance;
import mygame.game.utils.IValidatorEntity;

/**
 * ...
 * @author GINER Jérémy
 */
class ValiInRangeEntity implements IValidatorEntity {

	var _oEntity :Entity;
	var _fRadius :Float;
	
	var _oDistCache :EntityDistance;
	
	public function new( oEntity :Entity, fRadius :Float ) {
		_oEntity = oEntity;
		_fRadius = fRadius;
		
		_oDistCache = _oEntity.game_get().singleton_get(EntityDistance);
	}
	
	public function distCache_get() {
		return _oDistCache;
	}
	
	public function entity_get() {
		return _oEntity;
	}
	
	public function validate( oEntity :Entity ) {
		return _oDistCache.distanceSqed_get( _oEntity, oEntity ).get() <= _fRadius*_fRadius;
	}
}