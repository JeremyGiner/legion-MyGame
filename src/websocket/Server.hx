package websocket;

import trigger.eventdispatcher.EventDispatcherFunel;
import trigger.EventDispatcher2;

/**
 * Manage websocket connection.
 * @author GINER Jérémy
 */
class Server {
	
	var _bRunning :Bool;
	
	var _sHost :String;
	var _iPort :Int;
	
	var _oSocketMaster :SocketLocal;
	
	var _oSocketFactory :SocketDistantFactory;
	var _aSocketDistant :List<SocketDistant>;
	
	public var onAnyOpen :EventDispatcher2<SocketDistant>;
	public var onAnyMessage :EventDispatcherFunel<SocketDistant>;
	public var onAnyClose :EventDispatcherFunel<SocketDistant>;
	
//______________________________________________________________________________
//	Constructor
	
	public function new( 
		sHost :String = 'localhost', 
		iPort :Int = 8000, 
		oSocketFactory :SocketDistantFactory = null 
	){
		//TODO : check host/port
		_sHost = sHost;
		_iPort = iPort;
		_bRunning = false;
		
		_oSocketFactory = ( oSocketFactory != null ) ? oSocketFactory : new SocketDistantFactory();
		
		_aSocketDistant = new List<SocketDistant>();
		
		onAnyOpen = new EventDispatcher2<SocketDistant>();
		onAnyMessage = new EventDispatcherFunel<SocketDistant>();
		onAnyClose = new EventDispatcherFunel<SocketDistant>();
	}
//______________________________________________________________________________
//	Accessor

	public function running_check(){ return _bRunning; }

//______________________________________________________________________________
//	Modifier

	public function start() {
		_bRunning = true;
		
		_oSocketMaster = SocketLocal.create();
		_oSocketMaster.bind( _sHost, _iPort);
		_oSocketMaster.listen();
	}

//______________________________________________________________________________
//	Process
	
	public function socket_process() {
		
		if ( !_bRunning ) throw('[ERROR] Server : Server not started yet');
		
		// Acknowledge new client (if available)
		_socketAccept_process();
		
		// Process distant socket
		_socketMessage_process();
		
	}
	
//______________________________________________________________________________
//	Sub-routine

	/**
	 * Acknowledge new client (if available)
	 */
	function _socketAccept_process() {
		
		// Get new raw distant socket from master
		var oResource = _oSocketMaster.accept();
		
		// Case : no new socket available
		if ( oResource == null )
			return;
		
		// Turn the raw distant socket into proper object
		var oSocketDistant = _oSocketFactory.resource_set( oResource ).create();
		_aSocketDistant.push( oSocketDistant );
		
		// Funel event
		oSocketDistant.onMessage.attach( onAnyMessage );
		oSocketDistant.onClose.attach( onAnyClose );
		
		// Trigger event
		trace('[NOTICE] Server : new distant socket (#'+oSocketDistant.resource_get()+').');
		trace(oSocketDistant);
		onAnyOpen.dispatch( oSocketDistant );
	}
	
	/**
	 * Process distant socket
	 */
	function _socketMessage_process() {
		var aSocketDistantActive = new List<SocketDistant>();
		for ( oSocketDistant in _aSocketDistant ) {
			
			// Filter closed socket
			if ( oSocketDistant.closed_check() != false ) 
				continue;
			
			// Process new message
			oSocketDistant.process();
			
			// Filter closed socket ( due to the message processing )
			if ( oSocketDistant.closed_check() != false ) 
				continue;
			
			//
			aSocketDistantActive.push( oSocketDistant );
		}
		
		_aSocketDistant = aSocketDistantActive; // filter closed socket
	}
	
}
