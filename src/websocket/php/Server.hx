package websocket.php;

import trigger.eventdispatcher.EventDispatcherFunel;
import websocket.crypto.Hybi10;
import websocket.SocketDistantFactory;

import websocket.php.SocketLocal;
import websocket.php.SocketDistant;
import websocket.Server in BaseServer;
import trigger.EventDispatcher2;
/**
 * Manage a local socket and his connected distant socket.
 * 
 * @author GINER Jérémy
 */
class Server extends BaseServer {

	var _oSocketMaster :SocketLocal;
	
	var _oSocketFactory :SocketDistantFactory;
	var _aoSocketDistant :List<SocketDistant>;
	
	public var onAnyOpen :EventDispatcher2<SocketDistant>;
	public var onAnyMessage :EventDispatcherFunel<SocketDistant>;
	public var onAnyClose :EventDispatcher2<SocketDistant>;
	
//______________________________________________________________________________
//	Constructor

	public function new( sHost :String = 'localhost', iPort :Int = 8000, oSocketFactory :SocketDistantFactory = null ) {
		super( sHost, iPort );
		
		if ( oSocketFactory == null ) _oSocketFactory = new SocketDistantFactory();
		else _oSocketFactory = oSocketFactory;
		
		_aoSocketDistant = new List<SocketDistant>();
		
		onAnyOpen = new EventDispatcher2<SocketDistant>();
		onAnyMessage = new EventDispatcherFunel<SocketDistant>();
		onAnyClose = new EventDispatcher2<SocketDistant>();
	}

//______________________________________________________________________________
//	Accessor

	

//______________________________________________________________________________
//	Modifier

	override public function start() {
		_bRunning = true;
		
		_oSocketMaster = SocketLocal.create();
		_oSocketMaster.bind( _sHost, _iPort);
		_oSocketMaster.listen();
		
		trace('[NOTICE] SERVER : up and running.');
	}
/*
	override public function run(){
	
		super.run();
		
		//untyped __php__('ob_implicit_flush(true)');
		
		while( running_check() ){
			socket_process();
		}
	}*/
	
//______________________________________________________________________________
//	Process
	
	/*function onMessage( oSocketDistant :SocketDistant ) {
		trace( oSocketDistant.errorLast_get() );
	}*/
	
	public function socket_process() {
		
		if ( !_bRunning ) throw('Server not started yet');
		
		// Acknowledge new client (if available)
			var oResource = _oSocketMaster.accept();
			if ( oResource != null ) {
				var oSocketDistant = _oSocketFactory.resource_set( oResource ).create();
				_aoSocketDistant.push( oSocketDistant );
				oSocketDistant.onMessage.attach( onAnyMessage );
				trace('[NOTICE] SERVER : new distant socket (#'+oSocketDistant.resource_get()+').');
			}
		
		// Process distant socket
			var aoSocketDistantActive = new List<SocketDistant>();
			for ( oSocketDistant in _aoSocketDistant ) 
				if( oSocketDistant.closed_check() == false ) {
					oSocketDistant.process();
					
					// Re-check
					if( oSocketDistant.closed_check() == false )
						aoSocketDistantActive.push( oSocketDistant );	// filter closed socket
				}
			_aoSocketDistant = aoSocketDistantActive; // filter closed socket
		
	}

}