package websocket.php;

import trigger.eventdispatcher.*;

import websocket.crypto.Hybi10;
import websocket.php.Socket;
import websocket.Resource;

/**
 * Object allowing interaction with distant socket
 * 
 * @author GINER Jérémy
 */
class SocketDistant extends Socket {

	var _bHandshaked :Bool;
	var _sInBuffer :String;
	
	
	public var onMessage :EventDispatcher;
	
//______________________________________________________________________________
//	Constructor

	public function new( oResource :Resource ){
		super( oResource );
		
		_bHandshaked = false;
		_sInBuffer = '';
		
		//onMessage = new EventDispatcherTree( onAnyMessage );
		onMessage = new EventDispatcher();
		onClose = new EventDispatcher();
		
	}

//______________________________________________________________________________
//	Accessor

	public function isHandshaked_get() { return _bHandshaked; }
	
	
//______________________________________________________________________________
//	Process

	public function process() {
		
		var iLength = 4096;
		
		// Check if closed
		if ( closed_check() == true )
			return;
		
		// Try to read socket
		_sInBuffer = '';
		var iByteN :Int = untyped __call__( '@socket_recv', _oResource, _sInBuffer, iLength, 0 );	// @ : no error reporting
		
		
		// Error check
		if ( untyped iByteN == false ) {
			var error = untyped __call__('socket_last_error', _oResource );
			if( error != 0 )
				trace('[ERROR]:socket error:' + untyped __call__('socket_strerror', error ));
			return;	// Case : Error : The operation completed successfully. ( ??? )
		}
		
		// Check message
		if ( iByteN == 0 )
			return;	// No message available yet
		
		if ( _sInBuffer.length == 0 /* && iByteN != 0 */ ) {
			// Socket closed by client
			trace('[WARNING]:did not close proper way');
			_close();
			return;
		}
			
		// Handle message as handshake request
		if ( !isHandshaked_get() ) {
			_handshake( _sInBuffer );
			return;
		}
		// Turn raw message data into WSMessage
		//_sInBuffer = Hybi10.decode( _sInBuffer );
		var oMessage = Hybi10.decode( _sInBuffer );
		_sInBuffer = oMessage.payload_get();
		// Closing message
		if ( oMessage.opcode_get() == 8 ) {
			_close();
			return;
		}
		
		// Handle message as
		_message_handle();
	}
//______________________________________________________________________________
//	Sub-routine

	function _handshake( sHandshake :String ){
		write( Hybi10.handshake_get( sHandshake ) );
		_bHandshaked = true;
	}
	
	function _message_handle() {
		trace( '[NOTICE]:SocketDistant:message receive : ' + _sInBuffer );
		// Implement your handle here
		
		onMessage.dispatch( this );
	}
	
	
	
//______________________________________________________________________________
//	Utils
/*
	public function read( iLength :Int ):Int {
		
		// Try to read socket
		_sInBuffer = '';
		var iByteN :Int = untyped __call__( '@socket_recv', _oResource, _sInBuffer, iLength, 0 );	// @ : no error reporting
		
		// Error check
		var error = untyped __call__('socket_last_error', _oResource );
		if ( error != 0 )
			trace('[ERROR]:socket error:'+untyped __call__('socket_strerror', error ));
		
		// If no handshaked assume it's an encoded handshake
		if( isHandshaked_get() )
			_sInBuffer = Hybi10.decode( _sInBuffer );
		return iByteN;
	}*/

	public function write( sBuffer :String ):Int {
		var sOutBuffer :String = sBuffer;
		//trace('[DEBUG] SocketDistant : sending : '+sOutBuffer);
		if( isHandshaked_get() )
			sOutBuffer = Hybi10.encode( sOutBuffer );
		
		//trace('[DEBUG] SocketDistant : sending : '+sOutBuffer);
		return untyped __call__( 'socket_write', _oResource, sOutBuffer, sOutBuffer.length );
	}
	
	public function readResult_get():String { return _sInBuffer;}
	
	public function handshake( sHandshake :String ){
		_handshake( sHandshake );
	}
	

}