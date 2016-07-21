package mygame.game.utils;
import legion.entity.Entity;
import trigger.IEventDispatcher;
import utils.CascadingValue;
import utils.IValidator;

/**
 * ...
 * @author GINER Jérémy
 */
class CascadingValiEntity extends CascadingValue<Bool> {

	var _oEntity :Entity;
	var _oVali :IValidator<Entity>;
	
	public function new( oEntity :Entity, oVali :IValidator<Entity>, aDispatcher :Array<IEventDispatcher> ) {
		_oEntity = oEntity;
		_oVali = oVali;
		
		super( aDispatcher );
		
		_oValue = null;
	}
	
	public function entity_get() {
		return _oEntity;
	}
	
	override function _update() {
		
		_oValue = _oVali.validate( _oEntity );
	}
	
}