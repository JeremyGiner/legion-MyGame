package mygame.game.process;

import legion.entity.Entity;
import mygame.game.MyGame;
import mygame.game.ability.Weapon;
import mygame.game.collision.WeaponLayer;
import mygame.game.ability.Health;

import trigger.*;

class Death implements ITrigger {

	var _oGame :MyGame;
	
	var _lHealth :List<Health>;	// List of Health recently updated 

//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame ) {
		_oGame = oGame;
		_lHealth = new List<Health>();
		
		_oGame.onLoop.attach( this );
		_oGame.onHealthAnyUpdate.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor
	

	
//______________________________________________________________________________
//	Process
	
	function process() {
		
		while( !_lHealth.isEmpty() ) {
			var oHealth = _lHealth.pop();
			if( oHealth.get() == 0 )
				oHealth.unit_get().dispose();
		}
	} 
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		// on loop
		if( oSource == _oGame.onLoop )
			process();
		
		// on 
		if ( oSource == _oGame.onHealthAnyUpdate )
			_lHealth.push( _oGame.onHealthAnyUpdate.event_get() );
		
	}
}