package utils.time;

class TimerReal implements ITimer {
	var _iStart :Int;
	var _iExpire :Int;	//Expire time relative to start

	var _bLoop :Bool;

//______________________________________________________________________________
// Constructor

	public function new( iExpire :Int, bLoop :Bool = false ){
		_iExpire = iExpire;
		reset();
	}
	
//______________________________________________________________________________
// Accessor
	
	public function isExpired_get() :Bool {
		return expire_get()<0;
	}
	
	// number of millisec remaining before expire
	public function expire_get() :Int {
		return	(_iStart +_iExpire) - _timeNow_get();
	}
	
	public function expirePercent_get(){
		return _timeNow_get() / _iExpire;
	}
	
	public function reset() {
		_iStart = _timeNow_get();
	}
	
//______________________________________________________________________________
// Sub-routine

	function _timeNow_get() :Int {
		return Math.floor( Date.now().getTime() );
	}
	
	
}