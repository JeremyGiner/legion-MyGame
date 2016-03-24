package mygame;

import mygame.MyDisplayer;
import mygame.game.MyGame;

import legion.device.MegaMouse in Mouse;
import legion.device.Keyboard;

class Menu {

	private var _oGame :MyGame;
	private var _oGameView :GameView;

	private var _oMouse :Mouse;
	private var _oKeyboard :Keyboard;
	
	private var _oShipControl :ShipManualControl;
	private var _oStrategicZoom :StrategicZoom;
	
	private var _oUnitSelector :UnitSelector;
	private var _oUnitPilot :UnitPilot;
	
//______________________________________________________________________________
	
	public function new( oGame :MyGame, oGameView :GameView ){
		_oGame = oGame;
		_oGameView = oGameView;
		
	// Init devices
		_oMouse = new Mouse();
		_oKeyboard = new Keyboard();
		
		//_oShipControl = new ShipManualControl();
		_oStrategicZoom = new StrategicZoom( _oDisplayer );
		
		_oUnitSelector = new UnitSelector( _oGame, _oDisplayer, _oMouse );
		_oUnitPilot = new UnitPilot( _oGame, _oDisplayer, _oMouse, _oKeyboard );
		
		
		new GameVisualUpdater( _oGame, _oDisplayer );
		
		//new MouseTester( _oDisplayer, _oMouse );
		
		new TestGeneric().oDisplayer = _oDisplayer;
		
		js.Browser.window.setInterval( _oGame.loop, 250 );
	}
	
//______________________________________________________________________________
	
	
	
}