package mygame.client.controller;

import mygame.game.MyGame;
import js.html.WebSocket;

import js.html.MessageEvent;

class Synchronizer {
	private var _oGame :MyGame;
	
	private var _oWebSocket :WebSocket;
	
	
	//TODO : move to controller
//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame ){
		_oGame = oGame;
		
		_oWebSocket = new WebSocket('ws://127.0.0.1:8000/server/MyServer.php/server.php');

		_oWebSocket.onopen = function(t){
			trace('[NOTICE] : WebSocket : Connection open.');trace(t);
			_oWebSocket.send('Hi');
		}
		_oWebSocket.onclose = function(t){trace('[NOTICE] : WebSocket : Connection closed.');trace(t);}
		_oWebSocket.onmessage = function( oMessage :MessageEvent ){
			trace('[NOTICE] : WebSocket : Message : '+ oMessage.data);
		}
		_oWebSocket.onerror = function(t){trace('[ERROR] : WebSocket : ');trace(t);}
	}
	
//______________________________________________________________________________
//	Accessor

//______________________________________________________________________________
//	Utils
/*
	public function WebSocketSupport_check(){
		if( js.Browser.window.WebSocket )
			return true;
		if( js.Browser.window.MozWebSocket )
			return true;
		return false;
	}*/
	
	public function playerAction_add( ){
		_oGame.playerAction_add(  );
	}
	
	private function synchronize(){
		
	}

}