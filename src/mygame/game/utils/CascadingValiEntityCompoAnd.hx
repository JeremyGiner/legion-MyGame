package mygame.game.utils;
import legion.entity.Entity;
import mygame.game.query.EntityDistanceTile;
import trigger.IEventDispatcher;
import utils.CascadingValue;
import utils.IValidator;
import mygame.game.query.EntityDistance;
import mygame.game.ability.Loyalty;
import mygame.game.ability.Position;
import mygame.game.utils.validatorentity.ValiAbility;
import mygame.game.utils.validatorentity.ValiAlliance;
import mygame.game.utils.validatorentity.ValiAllianceEntity;
import mygame.game.utils.validatorentity.ValiInRangeEntity;
import mygame.game.utils.validatorentity.ValiInRangeEntityByTile;
import mygame.game.utils.validatorentity.ValiNotEntity;

/**
 * ...
 * @author GINER Jérémy
 */
class CascadingValiEntityCompoAnd extends CascadingValue<Bool> {

	var _oEntity :Entity;
	var _aVali :Array<IValidator<Entity>>;
	var _aCascadingVali :Array<CascadingValue<Bool>>;
	
	public function new( oEntity :Entity, aVali :Array<IValidator<Entity>> ) {
		_oEntity = oEntity;
		_aVali = aVali;
		
		_aCascadingVali = new Array<CascadingValue<Bool>>();
		
		super( [] );
		
		_oValue = true;
		
		// Init
		for ( i in 0..._aVali.length ) {
			
			// Add child cascading value
			_aCascadingVali[i] = new CascadingValiEntity( _oEntity, _aVali[i], _resolve( _oEntity, _aVali[i] ) );
			_aCascadingVali[i].onUpdate.attach( this );
			_aDispatcher.push( _aCascadingVali[i].onUpdate );
			
			//
			_oValue = _oValue && _aCascadingVali[i].get();
			
			if ( _oValue == false )
				break;
		}
	}
	
	public function entity_get() {
		return _oEntity;
	}
	
	
	function _resolve( oEntity :Entity, oVali :IValidator<Entity> ) {
		var aDispatcher = new Array<IEventDispatcher>();
		
		switch( Type.getClass( oVali ) ) {
			case ValiInRangeEntityByTile :
				aDispatcher = [
					oEntity.game_get().singleton_get(EntityDistanceTile).data_get([ oEntity, untyped oVali.entity_get() ]).onUpdate,
				];
			case ValiInRangeEntity :
				aDispatcher = [
					untyped oEntity.game_get().singleton_get(EntityDistance).data_get([ oEntity, untyped oVali.entity_get() ]).onUpdate,
				];
			case ValiAlliance, ValiAllianceEntity :
				aDispatcher = [
					oEntity.ability_get(Loyalty).onUpdate,
				];
			case ValiAbility :
				aDispatcher = [
					oEntity.onAbilityAdd,
					oEntity.onAbilityRemove
				];
			case ValiNotEntity :
				aDispatcher = [];
			default :
				throw('!!!!!!!!!');
		}
		
		return aDispatcher;
	}
	
	override function _update() {
		
		_oValue = true;
		for ( i in 0..._aVali.length ) {
			
			if( _aCascadingVali[i] == null ) {
				// Add child cascading value
				_aCascadingVali[i] = new CascadingValiEntity( _oEntity, _aVali[i], _resolve( _oEntity, _aVali[i] ) );
				_aCascadingVali[i].onUpdate.attach( this );
				_aDispatcher.push( _aCascadingVali[i].onUpdate );
			}
			
			//
			_oValue = _oValue && _aCascadingVali[i].get();
			
			if ( _oValue == false )
				break;//todo : remove every cascading validator after this point
		}
	}
	
	override public function dispose() {
		// Dispose children
		for ( o in _aCascadingVali )
			o.dispose();
		super.dispose();
	}
}