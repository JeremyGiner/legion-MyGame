package websocket;

import trigger.eventdispatcher.*;
import websocket.Resource;

/**
 * Abstract object allowing interaction with a socket
 * 
 * @author GINER Jérémy
 */
class Socket {

	var _oResource :Resource;
	var _bClosed :Bool;
	
	public var onClose :EventDispatcher;
	
//______________________________________________________________________________
//	Constructor

	function new( oResource :Resource ) {
		
		_oResource = oResource;
		_bClosed = false;
		onClose = new EventDispatcher();
		
		// Config
		untyped __call__( 'socket_set_nonblock', _oResource );
	}

//______________________________________________________________________________
//	Accessor

	public function resource_get() { return _oResource; }
	public function closed_check() {
		return _bClosed;
	}
	
//______________________________________________________________________________
//	Method

	
	public function close() {
		untyped __call__( 'socket_close', _oResource );
		_close();
	}
	
	public function errorLast_get(){
		var iErrorCode :Dynamic = untyped __call__( 'socket_last_error', _oResource );
		return untyped __call__('socket_strerror', iErrorCode );
	}
	
//______________________________________________________________________________
//	Sub-routine
	
	
	function _close() {
		_bClosed = true;
		onClose.dispatch( this );
	}
	

}
