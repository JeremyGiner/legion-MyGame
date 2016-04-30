package mygame.client.model;

import js.Browser;
import mygame.connection.message.serversent.RoomUpdate;
import websocket.IMessage;

import trigger.*;
import trigger.eventdispatcher.*;

import js.html.WebSocket;
import js.html.MessageEvent;

import mygame.connection.*;
import mygame.connection.message.*;

import haxe.Serializer;
import haxe.Unserializer;
import websocket.MessageComposite;

class Connection implements ITrigger {

	var _oModel :Model;
	var _oWebSocket :WebSocket = null;
	var _bOpen :Bool = false;
	var _oMySerializer :MySerializer;
	
	var _onUnload :EventDispatcherJS;
	
	//_____
	
	var _oMessageLast :IMessage;
	
	//_____
	
	public var onOpen :EventDispatcher;
	public var onMessage :EventDispatcher;
	public var onClose :EventDispatcher;
	
//______________________________________________________________________________
//	Constructor

	public function new( oModel ) {
		
		_oModel = oModel;
		
		onOpen = new EventDispatcher();
		onMessage = new EventDispatcher();
		onClose = new EventDispatcher();
		
		_oMySerializer = new MySerializer();
		_oMySerializer.useCache = true;
		
		_onUnload = new EventDispatcherJS( 'beforeunload' );
		_onUnload.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor

	public function open_check() { return _bOpen; }
	public function messageLast_get() { return _oMessageLast; }

//______________________________________________________________________________
//	

	public function send( oMessage :IMessage ) {
		// Set relative (TODO : find a way to define this inside ReqPlayerInput, ResGameStepInput ....)
		Serializer.USE_CACHE = true;
		if ( Std.is( oMessage, ReqPlayerInput ) || Std.is( oMessage, ResGameStepInput ) )
			MySerializer._bUSE_RELATIVE = true;
		else
			MySerializer._bUSE_RELATIVE = false;
		
		//Serialize and send
		_oWebSocket.send( MySerializer.run( oMessage ) );
	}
	
	function receive( oMessage :MessageEvent ) {
		// Unserialize
		var oMessageTmp = MyUnserializer.run( oMessage.data, _oModel.game_get() );
		//_oMessageLast = Unserializer.run( oMessage.data );
		
		// Case : composite message
		if ( Std.is( oMessageTmp, MessageComposite ) ) {
			for ( oMessage in cast(oMessageTmp, MessageComposite).componentArray_get() ) {
				_oMessageLast = oMessage;
				onMessage.dispatch( this );
			}
		}
		
		// Case : simple message
		_oMessageLast = oMessageTmp;
		onMessage.dispatch( this );
	}
	
//______________________________________________________________________________
//	Utils
	
	public function connect() {
		// Init Websocket	
		_oWebSocket = new WebSocket('ws://127.0.0.1:8000/server/MyServer/server.php');

		_oWebSocket.onopen = function(t) { 
			trace('[NOTICE] : WebSocket : Connection open.');
			//_oWebSocket.send('Hidiho');
			_bOpen = true;
			onOpen.dispatch( this ); 
		}
		
		_oWebSocket.onclose = function(t) {
			trace('[NOTICE] : WebSocket : Connection closed by server.');
			_bOpen = false;
			onClose.dispatch( this );
		}
		
		_oWebSocket.onmessage = receive;
		
		/*function( oMessage :MessageEvent ){
			//trace('[NOTICE] : WebSocket : Message : '+ oMessage.data);
			_oMessageLast = haxe.Unserializer.run( oMessage.data );
			onMessage.dispatch( this );
		}*/
		
		_oWebSocket.onerror = function(t) {trace('[ERROR] : WebSocket : ');trace(t);}
	}
	
	public function close() {
		
		_oWebSocket.close();
		_bOpen = false;
		
		trace('[NOTICE] : WebSocket : Connection closed by client.');
		
		onClose.dispatch( this );
	}
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ){
		if ( oSource == _onUnload ) {
			close();
		}
	}
}


