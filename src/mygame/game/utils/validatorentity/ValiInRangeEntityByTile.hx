package mygame.game.utils.validatorentity;
import legion.ability.IAbility;
import legion.entity.Entity;
import legion.entity.Player;
import mygame.game.ability.Loyalty;
import mygame.game.ability.Position;
import mygame.game.query.EntityDistanceTile;
import mygame.game.query.EntityDistance;
import mygame.game.utils.IValidatorEntity;

/**
 * ...
 * @author GINER Jérémy
 */
class ValiInRangeEntityByTile implements IValidatorEntity {

	var _oEntity :Entity;
	var _iTileDist :Int;
	
	var _oQueryDist :EntityDistanceTile;
	
	public function new( oEntity :Entity, fRadius :Float ) {
		_oEntity = oEntity;
		_iTileDist = Position.metric_unit_to_maptile( Math.ceil(fRadius) )+1;
		
		_oQueryDist = oEntity.game_get().singleton_get(EntityDistanceTile);
	}
	
	public function entity_get() {
		return _oEntity;
	}
	
	public function validate( oEntity :Entity ) {
		
		return _oQueryDist.data_get([_oEntity,oEntity]).get() <= _iTileDist;
	}
}