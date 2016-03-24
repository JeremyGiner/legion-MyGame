package legion;

class Timer {
	private var _iStart :Int;
	private var _iExpire :Int;	//Expire time absolute
	//private var _callback;
	private var _bLoop :Bool;

//______________________________________________________________________________
// Constructor

	public function new( iExpire :Int, bLoop :Bool = false ){
		
		_iStart = cast Date.now().getTime();
		_iExpire = _iStart + iExpire;
		
		//js.Lib.alert( 'time :' + Date.now().getTime() + ' ' + _iStart );
	}
	
//______________________________________________________________________________
// Accessor
	
	public function isExpire_get():Bool{
		return _iExpire < Date.now().getTime();
	}
	
	public function expire_get():Int{
		return (cast Date.now().getTime()) - _iExpire;
	}
	
	public function expirePercent_get(){
		return Date.now().getTime() / _iExpire;
	}
}