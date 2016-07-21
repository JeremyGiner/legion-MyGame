package mygame.client.controller.game;

import haxe.Serializer;
import js.Browser;
import mygame.connection.MySerializer;
import haxe.Timer;
import js.Lib;
import mygame.ai.Nemesis0;
import trigger.*;
import utils.time.TimerReal;

import mygame.game.MyGame;
import mygame.game.action.IAction;

import mygame.client.controller.*;
import mygame.client.controller.game.*;
import mygame.client.view.*;

import legion.PlayerInput;
import legion.device.MegaMouse in Mouse;
import legion.device.Keyboard;

import mygame.trigger.*;

import mygame.client.model.GUI;
import mygame.client.model.Model;

class GameControllerLocal extends GameController {
	
	var _oGameSpeed :GameSpeed;
	var _iIntervalKey :Int;
	
	var _aAIPlayer :Array<Nemesis0>;
	
	var _bPaused :Bool;
	
//______________________________________________________________________________
	
	public function new( oModel :Model, aAIPlayer :Array<Nemesis0> ){
		super( oModel );
		
		_iIntervalKey = Browser.window.setTimeout( _game_process, 45 );
		
		_bPaused = false;
		
		_aAIPlayer = aAIPlayer;
		
		//_oGameSpeed = new GameSpeed( _oGame, 45 );	//TODO : change into timer
		//js.Browser.window.setInterval( _oGame.loop, 250 );
	}
	
//______________________________________________________________________________
// Accessor

	
	public function gamespeed_get() { return _oGameSpeed; }
	
//______________________________________________________________________________
//	Moifier

	override public function pause_toggle() {
		trace('pausing');
		_bPaused = !_bPaused;
	}
	
	
//______________________________________________________________________________
// Trigger


	

	override public function trigger( oSource :IEventDispatcher ) {
		super.trigger( oSource );
		// On press
		if( oSource == _oKeyboard.onUpdate ){
			//KEY "L"
			if( _oKeyboard.keyTrigger_get() == 'l' ) {
				//trace( _oGame.log_get()  );
				Serializer.USE_CACHE = true;
				MySerializer._bUSE_RELATIVE = true;
				trace( MySerializer.run( _oGame.log_get() ) );
			}
		}
	}
	
//______________________________________________________________________________
// Subroutine
	
	function _game_process() {
			if ( _bPaused )
				return;
			
			var iTime = Date.now().getTime();
			
			// Process game
			_oGame.loop();
			
			iTime = Date.now().getTime() - iTime;
			
			if ( iTime > 45 && _oGame.loopId_get() % 44 == 0 )
				trace('overtime'+iTime);
			
			// Process AI
			for ( oNemesis in _aAIPlayer ) {
				if ( oNemesis == null )
					continue;
				
				var aAction = oNemesis.action_get();
				
				for ( oAction in aAction ) {
					_oGame.action_run( oAction );
				}
			}
			
			
			// Check end of game			
			var oWinner = _oGame.winner_get();
			if ( oWinner == null ) {
				_iIntervalKey = Browser.window.setTimeout( _game_process, 45 );
				return;
			}
				
			// Display win screen
			Browser.alert(oWinner.name_get()+ '(#'+oWinner.playerId_get()+') win the game');
	}
	
//______________________________________________________________________________
//	Trigger

	override public function dispose() {
		Browser.window.clearTimeout( _iIntervalKey );
	}
	
}
