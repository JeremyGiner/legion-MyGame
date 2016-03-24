package mygame.client.controller.game;

import js.Browser;
import trigger.*;

import mygame.game.MyGame;
import mygame.game.action.IAction;

import mygame.client.controller.*;
import mygame.client.controller.game.*;
import mygame.client.view.*;
import mygame.game.entity.Player;

import legion.device.MegaMouse in Mouse;
import legion.device.Keyboard;

import mygame.trigger.*;

import mygame.client.model.GUI;
import mygame.client.model.Model;

/**
 * Controller for MyGame, it process keyboard, mouse and HTMLbutton event 
 * to produce Actions or modification on the GameView.
 * Some of those process are delegate to other class such as :
 *  - UnitPilot
 *  - StrategicZoom
 * 
 * @author GINER Jérémy
 */
class GameController implements ITrigger implements IGameController {

	var _oModel :Model;
	var _oGame :MyGame;
	
	var _oGUI :GUI;
	var _oGameView :GameView;

	var _oMouse :Mouse;
	var _oKeyboard :Keyboard;
	
	//var _oShipControl :ShipManualControl;
	var _oStrategicZoom :StrategicZoom;
	
	//var _oUnitSelector :UnitSelector;
	var _oUnitPilot :UnitPilot;
	
	
//______________________________________________________________________________
	
	function new( 
		oModel :Model
	){
		_oModel = oModel;
		_oGame = oModel.game_get();
		_oGUI = oModel.GUI_get();
		
		_oGameView = new GameView( _oModel );
	// Init devices
		
		_oMouse = _oModel.mouse_get();
		_oKeyboard = _oModel.keyboard_get();
	
	//___
		//_oShipControl = new ShipManualControl();
		_oStrategicZoom = new StrategicZoom( _oGameView, _oMouse );
		
		//_oUnitSelector = new UnitSelector( _oGame, _oGameView, _oMouse );
		_oUnitPilot = new UnitPilot( this, _oGameView, _oModel, _oMouse, _oKeyboard );
		
		
		//new MouseTester( _oDisplayer, _oMouse );
		
		//new TestGeneric().oDisplayer = _oDisplayer;

		new UnitDirectControl( 
			this,
			_oModel,	// Last entity
			_oKeyboard
		);
		
		/*
		new CameraTracking(
			cast _oGame.entity_get_all()[ _oGame.entity_get_all().length-1 ],
			_oGameView
		);*/
		
		//______
		_oKeyboard.onUpdate.attach( this );
		
		// Test
		/*_oGUI.unitSelection_get().unit_add(
			_oGame.hero_get( _oModel.playerLocal_get() )
		);*/
		
		new UnitSelection(
			this, 
			_oGameView,
			_oModel,
			_oMouse,
			_oKeyboard
		);
		new Menu(
			this, 
			_oGameView,
			_oModel
		);
	}
	
//______________________________________________________________________________
// Accessor
	
	public function action_add( oAction :IAction ) {
		
		// Immediate run of the action
		_oGame.action_run( oAction );
	}
	
	public function game_get() { return _oGame; }
	
	public function model_get() { return _oModel; }
//______________________________________________________________________________
// 

	public function pause_toggle() {
		throw 'Abstract';
	}
//______________________________________________________________________________
// Trigger

	public function trigger( oSource :IEventDispatcher ) {
	
		// SCR : https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent
		//https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent.code
		
		// On press
		if( oSource == _oKeyboard.onPress ){
		
			//SHIFT
			if( _oKeyboard.keyTrigger_get() == 0x10 )
				_oGUI.mode_set( 1 );
		}
		
		// On release
		if( oSource == _oKeyboard.onRelease ){
			//SHIFT
			if( _oKeyboard.keyTrigger_get() == 0x10 )
				_oGUI.mode_set( 0 );
		}
	}
}