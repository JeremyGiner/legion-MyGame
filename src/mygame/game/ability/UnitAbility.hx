package mygame.game.ability;
import legion.ability.IAbility;
import mygame.game.entity.Unit;
import trigger.eventdispatcher.EventDispatcher;
import utils.Disposer;

/**
 * Ability bound to a mygame Unit
 * @author GINER Jérémy
 */
class UnitAbility implements IAbility {

	var _oUnit :Unit;
	
//______________________________________________________________________________
//	Constructor

	public function new( oUnit :Unit ) {
		_oUnit = oUnit;
	}
	
//______________________________________________________________________________
//	Accessor

	public function unit_get() { return _oUnit; }
	
	public function mainClassName_get() {
		return Type.getClassName( Type.getClass( this ) );
	}
	
//______________________________________________________________________________
//	Disposer
	
	public function dispose() {
		
		// Wipe all
		Disposer.dispose( this );
	}
	
	
}