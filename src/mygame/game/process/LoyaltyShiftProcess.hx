package mygame.game.process;

import legion.entity.Entity;
import mygame.game.MyGame;
import mygame.game.entity.Unit;

import collider.CollisionEventPrior in CollisionEvent;

import trigger.*;
import trigger.eventdispatcher.*;

import mygame.game.ability.LoyaltyShift;

class LoyaltyShiftProcess implements ITrigger {

	var _oGame :MyGame;
	var _lAbility :List<LoyaltyShift>;

//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame ) {
		_oGame = oGame;
		_lAbility = new List<LoyaltyShift>();
		
		_oGame.onLoop.attach( this );
		_oGame.onEntityNew.attach( this );
		_oGame.onEntityDispose.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor
	

	
//______________________________________________________________________________
//	Process
	
	function process() {
		
		// Process each ability LoyaltyShift
		for( oAbility in _lAbility ) {
			oAbility.process();
		}
		
	} 
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		// on loop
		if( oSource == _oGame.onLoop )
			process();
		
		// on new mobile entity
		if( oSource == _oGame.onEntityNew ) {
			var oAbility = _oGame.onEntityNew.event_get().ability_get( LoyaltyShift );
			if( oAbility != null ) {
				_lAbility.push( oAbility );
			}
		}
		
		
		if ( oSource == _oGame.onEntityDispose ) {
			var oAbility = _oGame.onEntityNew.event_get().ability_get( LoyaltyShift );
			if( oAbility != null ) {
				_lAbility.remove( oAbility );
			}
		}
	}
}