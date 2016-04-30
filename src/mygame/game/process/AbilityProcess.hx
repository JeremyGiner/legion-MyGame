package mygame.game.process;

import legion.entity.Entity;
import mygame.game.MyGame;
import mygame.game.ability.Weapon;
import mygame.game.ability.UnitAbility in Ability;

import trigger.*;

//TODO: cf LoyaltyShiftProcess
class AbilityProcess<CAbility:Ability> implements ITrigger {

	var _oGame :MyGame;
	
	var _lAbility :List<CAbility>;	// List of CAbility recently updated 

//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame ) {
		_oGame = oGame;
		_lAbility = new List<CAbility>();
		
		_oGame.onLoop.attach( this );
		_oGame.onCAbilityAnyUpdate.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor
	

	
//______________________________________________________________________________
//	Process
	
	function process() {
		
		while( !_lAbility.isEmpty() ) {
			var oCAbility = _lAbility.pop();
			if( oCAbility.get() == 0 )
				oCAbility.unit_get().dispose();
		}
	} 
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		// on loop
		if( oSource == _oGame.onLoop )
			process();
		
		// on 
		if ( oSource == _oGame.onCAbilityAnyUpdate )
			_lAbility.push( _oGame.onCAbilityAnyUpdate.event_get() );
		
	}
}