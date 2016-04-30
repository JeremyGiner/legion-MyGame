package mygame.client.controller.game;

import js.Browser;
import js.html.Element;
import js.Lib;
import mygame.connection.message.clientsent.ReqReadyUpdate;
import trigger.*;
import utils.time.TimerReal;

import mygame.game.MyGame;
import mygame.game.action.IAction;

import mygame.connection.message.*;

import mygame.game.action.UnitDirectControl in ActionUnitControl;
import mygame.game.action.UnitOrderMove in ActionUnitOrderMove;

import mygame.client.controller.*;
import mygame.client.controller.game.*;
import mygame.client.view.*;
import mygame.client.model.Connection;

import legion.PlayerInput;
import legion.device.MegaMouse in Mouse;
import legion.device.Keyboard;

import mygame.trigger.*;

import mygame.client.model.GUI;
import mygame.client.model.Model;

import websocket.IMessage;

/**
 * Controller reserved for online game.
 * 
 * @author GINER Jérémy
 */
class GameControllerOnline extends GameController implements ITrigger  {
	
	//Game update
	var _oPace :TimerReal;
	var _bUpdateReady :Bool;
	
	// Test
	var _iTime :Int = 0;
	var _iLatency :Int = 0;
	var _iDelayedLoop :Int = 0;
	var _oElement :Element;
	
//______________________________________________________________________________
//	Constructor
	
	public function new( 
		oModel :Model,
		fGameSpeed :Float
	){
		super( oModel );
		
		// Check connection
		if ( _oModel.connection_get() == null ) throw( 'GameControllerOnline require a connection. Model is not ready.' );
		
		_oModel.connection_get().onMessage.attach( this );
		
		// Game update
		_oPace = new TimerReal( 45 );	//TODO: use dynamic value from server.room
		_bUpdateReady = false;
		
		// Test
		//js.Browser.window.setInterval( _game_update, 0 );
		
		// Latency ( TODO : move to the view )
		_oElement = Browser.document.getElementById( 'TimeT' );
		js.Browser.window.setInterval( _time_display, 1000 );
	}
	
//______________________________________________________________________________
//	Accessor
	
	override public function action_add( oAction :IAction ) {
		trace('sending inputs');
		_oModel.connection_get().send( new ReqPlayerInput( oAction ) );
	}
	
//______________________________________________________________________________
//	

	function _game_update() {
		//trace('update attempt : '+_bUpdateReady+';'+_oPace.expire_get());
		// Running game loop when ready
		if ( _bUpdateReady && _oPace.isExpired_get() ) {
			_game_update_force();
			//trace('deklayed :' + _iDelayedLoop);
			_iDelayedLoop = 0;
		} else {
			_iDelayedLoop++;
		}
	}
	function _game_update_force() {
		_bUpdateReady = false;
		_oPace.reset();
		_oGame.loop();
	}
	
	function _time_display() {
		_oElement.innerHTML = 'Latency:'+(_iLatency-45);
	}
	
	override public function pause_toggle() {
		trace('pause toggle');
		
		var b = !_oModel.userInfoCurrent_get().ready;
		_oModel.connection_get().send( new ReqReadyUpdate(b) );
	}
	
//______________________________________________________________________________
// Trigger

	override public function trigger( oSource :IEventDispatcher ) {
	
		super.trigger( oSource );
		
		// On server message
		if( oSource == _oModel.connection_get().onMessage ){
			var oMessage :IMessage = _oModel.connection_get().messageLast_get();
			if( !Std.is(oMessage,IGameMessage) ) return; // Process only GameMessage (not LobbyMessage)
			switch( Type.getClass( oMessage ) ) {
				//case null :
					
				case ResGameStepInput : 
					var oResGameStepInput = cast(oMessage,ResGameStepInput);
					
					// Check if lagging
					if ( _bUpdateReady ) {
						//trace('Congestion! : '+_oPace.expire_get());
						//Force update
						_game_update_force();
					}
					
					//Check loop id
					if ( oResGameStepInput.loopId_get() != _oGame.loopId_get() ) {
						_oModel.disconnect();
						trace('[ERROR]:Invalid game step distant #'+oResGameStepInput.loopId_get()+' local #'+(_oGame.loopId_get()));
						Browser.alert('Disconnected due to a desync.');
						
					}
					
					// Running inputs
					for( oInput in oResGameStepInput.inputList_get() ) {
						_oGame.action_run( oInput );
					}
					
					// Test latency
					//trace( 'Latency:' + (Date.now().getTime() - _iTime) );
					_iLatency = Math.floor( Date.now().getTime() ) - _iTime;
					_iTime = cast Date.now().getTime();
					
					
					
					// Set ready
					_bUpdateReady = true;
					
					// Try to update game
					//_game_update();
					js.Browser.window.setTimeout( _game_update, 40 );
					
				default :
					throw('can not process this message type : '+Type.getClassName(Type.getClass( oMessage ) ) );
			}
		}
	}
}