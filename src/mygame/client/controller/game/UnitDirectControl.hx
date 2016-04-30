package mygame.client.controller.game;

import mygame.client.model.Model;
import space.Vector2i;
import trigger.*;
import mygame.game.entity.Unit;
import mygame.game.MyGame;
import legion.device.Keyboard;

import mygame.game.action.UnitDirectControl;
import mygame.game.action.UnitDirectControl in Action;

class UnitDirectControl implements ITrigger {
	var _iUp :Int = 0x5A; //KeyZ (windows Azerty)
	var _iRight :Int = 0x44; //KeyQ
	var _iLeft :Int = 0x51;
	var _iDown :Int = 0x53; //KeyS
	
	var _oKeyboard :Keyboard;
	
	var _bModified :Bool;
	
	var _oDirection :Vector2i;
	var _oGameController :GameController;
	
//______________________________________________________________________________
//	Constructor

	public function new( oGameController, oModel :Model, oKeyboard :Keyboard) {

		_oKeyboard = oKeyboard;
		_oGameController = oGameController;
		
		_oDirection = new Vector2i();
		
		_oKeyboard.onUpdate.attach( this );
		
		_bModified = false;
		
	}
	
//______________________________________________________________________________
//	
	function direction_set_X( x :Int ) {
		_oDirection.x = x;
		_bModified = true;
	}
	function direction_set_Y( y :Int ) {
		_oDirection.y = y;
		_bModified = true;
	}

//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) {
		//trace( 'start' + _oKeyboard.keyTrigger_get() +' ' + (oSource == _oKeyboard.onUpdate) );
		
		if( oSource == _oKeyboard.onUpdate ) {
			if( 
				(
					_oKeyboard.keyTrigger_get() == _iUp ||
					_oKeyboard.keyTrigger_get() == _iDown ||
					_oKeyboard.keyTrigger_get() == _iRight ||
					_oKeyboard.keyTrigger_get() == _iLeft
				)
			) {
				
				// Y axis
				if( _oKeyboard.keyState_get( _iUp ) == true ) {
					direction_set_Y( 10000 );
				} else 
					if( _oKeyboard.keyState_get( _iDown ) == true ) {
						direction_set_Y( -10000 );
					} else 
						direction_set_Y( 0 );
				
				// X axis
				if( _oKeyboard.keyState_get( _iRight ) == true ) {
					direction_set_X( 10000 );
				} else
					if( _oKeyboard.keyState_get( _iLeft ) == true  ) {
						direction_set_X( -10000 );
					} else
						direction_set_X( 0 );
						
				// Send Action
				if( _bModified ) {
					_bModified = false;
					_oGameController.action_add(
						new Action(
							_oGameController.model_get().playerLocal_get(),
							_oDirection
						)
					);
				}
			}
			
			
			
		}

	}
}