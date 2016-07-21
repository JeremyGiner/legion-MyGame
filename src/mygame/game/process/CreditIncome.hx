package mygame.game.process;

import haxe.ds.IntMap;
import legion.entity.Entity;
import mygame.game.MyGame;
import mygame.game.ability.Health;

import trigger.*;

class CreditIncome implements ITrigger {

	var _oGame :MyGame;

//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame ) {
		_oGame = oGame;
		
		// Trigger
		_oGame.onLoop.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor
	

	
//______________________________________________________________________________
//	Process
	
	function _process() {
		
		// Every 2 second (2000/45=44)
		if ( _oGame.loopId_get()%(Math.round(6000/45)) != 0 ) 
			return;
		
		for ( oPlayer in _oGame.player_get_all() ) {
			oPlayer.credit_add( 10 );
		}
	} 
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		// on loop
		if( oSource == _oGame.onLoop )
			_process();
		
	}
}