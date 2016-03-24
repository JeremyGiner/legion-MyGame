package websocket.php;

import websocket.crypto.Hybi10;
import websocket.php.SocketDistant;
import websocket.php.Socket;
import websocket.Resource;

/**
 * Local socket, once bind, allow to connect and interract with distant socket throught SocketDistant
 * 
 * @author GINER Jérémy
 */
class SocketLocal extends Socket {
	
//______________________________________________________________________________
//	Constructor

	function new( oResource :Resource ){
		super( oResource );
	}

	public function accept() {
		var oResource :Resource =  untyped __call__( '@socket_accept', _oResource );
		if( oResource == false )
			return null;
		return oResource;//new SocketDistant( oResource );
	}
	
	public static function create() {
		return new SocketLocal( untyped __php__( 'socket_create( AF_INET, SOCK_STREAM, SOL_TCP )') );
	}
	
//______________________________________________________________________________
//	Method
	
	public function bind( sHost :String = '127.0.0.1', iPort :Int = 8000 ) {
		untyped __call__( 'socket_bind', _oResource, sHost, iPort );
	}
	
	public function listen( iBacklog :Int = 0) {
		untyped __call__( 'socket_listen', _oResource, iBacklog );
	}
	
	public function write( sBuffer :String ):Int {
		return untyped __call__( 'socket_write', _oResource, sBuffer, sBuffer.length );
	}
	
	

}