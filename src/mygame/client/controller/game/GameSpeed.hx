package mygame.client.controller.game;

import mygame.game.MyGame;

class GameSpeed {

	var _iInterval :Int;
	var _oGame :MyGame;

	var _iTimestamp :Int;	// Timestamps of end of last executed loop
	var _JSTimerID :Dynamic;
	
//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame, iInterval :Int = 45 ) {
	
		_oGame = oGame;
		_iInterval = iInterval;
		
		timestamp_reset();
		
		_JSTimerID = js.Browser.window.setInterval( _oGame.loop, _iInterval );
	}

//______________________________________________________________________________
//	Accessor

	//Percent of time elapsedin between loop
	public function interpFactorPercent_get() :Float {
		return ( Date.now().getDate() - _iTimestamp ) /  _iInterval ;
	}
	
	public function speed_set( iTime :Int ) { _iInterval = iTime; }
	
	public function speed_get() :Int { return _iInterval; }
	
//______________________________________________________________________________
//	Utils

	private function timestamp_reset() {
		_iTimestamp = Date.now().getDate();
	}
	
}