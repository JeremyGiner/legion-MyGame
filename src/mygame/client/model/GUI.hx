package mygame.client.model;

import mygame.game.MyGame in Game;
import trigger.eventdispatcher.*;

import mygame.game.entity.Unit;

class GUI {

	var _oGame :Game = null;
	var _oUnitSelection :UnitSelection;
	
	public var _iMode :Int;	//0 : common; 1:order and health
	
	public var onModeChange :EventDispatcher;

//______________________________________________________________________________
//	Constructor

	public function new( oGame :Game ) {
		_oGame = oGame;
		_iMode = 0;
		
		_oUnitSelection = new UnitSelection( _oGame );
		
		onModeChange = new EventDispatcher();
	}
	
//______________________________________________________________________________
//	Accessor

	public function game_get() { return _oGame; }

	public function mode_get() { return _iMode; }
	public function mode_set( iMode :Int ) {
		_iMode = iMode;
		onModeChange.dispatch( this );
	}
	
	public function unitSelection_get() { return _oUnitSelection; }
}