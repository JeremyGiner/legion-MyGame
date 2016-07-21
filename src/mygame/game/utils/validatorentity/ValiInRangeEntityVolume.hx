package mygame.game.utils.validatorentity;
import legion.ability.IAbility;
import legion.entity.Entity;
import legion.entity.Player;
import mygame.game.ability.Loyalty;
import mygame.game.query.EntityDistance;
import mygame.game.query.EntityDistance;
import mygame.game.utils.IValidatorEntity;
import mygame.game.query.WatcherRangeEntity;

/**
 * ...
 * @author GINER Jérémy
 */
class ValiInRangeEntity implements IValidatorEntity {

	var _oEntity :Entity;
	var _fRadius :Float;
	
	var _oWatcher :WatcherRangeEntity;
	var _oDistCache :EntityDistance;
	
	var _iWatcherListenerId :Int;
	
	public function new( oEntity :Entity, fRadius :Float, oWatcher :WatcherRangeEntity, iWatcherListenerId :Int ) {
		_oEntity = oEntity;
		_fRadius = fRadius;
		
		_iWatcherListenerId = iWatcherListenerId;
		_oWatcher = oWatcher;
		
		_oDistCache = _oEntity.game_get().singleton_get(EntityDistance);
	}
	
	public function distCache_get() {
		return _oDistCache;
	}
	
	public function validate( oEntity :Entity ) {
		_oWatcher.listen( _iWatcherListenerId, [ _oEntity, oEntity ] );
		return _oDistCache.distanceSqed_get( _oEntity, oEntity ) <= _fRadius*_fRadius;
	}
}