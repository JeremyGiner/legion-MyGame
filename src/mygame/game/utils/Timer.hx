package mygame.game.utils;

import mygame.game.MyGame;

class Timer /*implements ITimer*/ {

	var _oGame :MyGame;
	
	//____

	var _iStart :Int;
	var _iFrequency :Int;
	
	var _iExpired :Int;

	var _bLoop :Bool;
	
	//___

//______________________________________________________________________________
// Constructor

	public function new( oGame :MyGame, iFrequency :Int, bLoop :Bool = false ){
		_oGame = oGame;
		
		set( iFrequency, bLoop );
	}
	
//______________________________________________________________________________
// Accessor
	
	public function reset(){ 
		_iStart = timeCurrent_get(); 
		_iExpired = _iStart + _iFrequency;
	}
	
	public function set( iFrequency :Int, bLoop :Bool = false ){
		//TODO : check if freq < 0
		_iFrequency = iFrequency;
		reset();
	}
	
	public function expired_check(){ return _iExpired < timeCurrent_get(); }
	
	public function timeCurrent_get() { return _oGame.loopId_get(); }
	public function timeRemain_get() { return timeCurrent_get() - _iExpired; }
	public function expire_get() { return _iExpired; }
		
	public function expirePercent_get() {
		return ( timeCurrent_get() - _iStart ) / ( _iExpired - _iStart );
	}
	
	
}