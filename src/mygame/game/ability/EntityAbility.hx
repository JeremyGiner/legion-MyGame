package mygame.game.ability;
import legion.ability.IAbility;
import legion.entity.Entity;
import utils.Disposer;

/**
 * Ability bound to a mygame Entity
 * @author GINER Jérémy
 */
class EntityAbility implements IAbility {

	var _oEntity :Entity;
	
//______________________________________________________________________________
//	Constructor

	public function new( oEntity :Entity ) {
		_oEntity = oEntity;
	}
	
//______________________________________________________________________________
//	Accessor

	public function entity_get() { return _oEntity; }
	
}