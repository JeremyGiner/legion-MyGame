package websocket;

/**
 * Abstract object which manage websocket connection.
 */
class Server {
	
	var _sHost :String;
	var _iPort :Int;
	
	var _bRunning :Bool;
	
//______________________________________________________________________________
//	Constructor
	
	function new( sHost :String = 'localhost', iPort :Int = 8000 ){
		//TODO : check host/port
		_sHost = sHost;
		_iPort = iPort;
		_bRunning = false;
	}
//______________________________________________________________________________
//	Accessor

	public function running_check(){ return _bRunning; }

//______________________________________________________________________________
//	Modifier

	public function start() { _bRunning = true; }
	public function stop(){ _bRunning = false; }

//______________________________________________________________________________
//	Method

	//public function run(){ _bRunning = true; };
}