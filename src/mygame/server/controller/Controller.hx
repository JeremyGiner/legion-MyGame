package mygame.server.controller;

import mygame.game.MyGame;
import mygame.server.misc.ClientFactory;
import mygame.server.model.Model;
import websocket.php.Server in PHPWSServer;
import websocket.php.SocketDistant in PHPWSClient;
import mygame.server.model.Client;

import mygame.server.model.RoomManager;
import haxe.ds.StringMap;

import trigger.*;

import mygame.server.controller.*;

/**
 * Controller for MyServer
 * 
 * @author GINER Jérérmy
 */
class Controller implements ITrigger {

	var _oModel :Model;
	
	var _oClientController :ClientController;
	
	var _oRoomManager :RoomManager;
	
	var _oServer :PHPWSServer;

//______________________________________________________________________________
//	Constructor

	public function new( oModel :Model ){
		_oModel = oModel;
		
		
		_oRoomManager = new RoomManager();
		_oRoomManager.game_create();
		_oRoomManager.game_create();
		_oRoomManager.game_create();
		
		
		_oServer = new PHPWSServer( 'localhost', 8000, new ClientFactory() );
		_oServer.start();
		
		_oServer.onAnyOpen.attach( this );
		
		_oClientController = new ClientController( this, _oRoomManager );	//require a server
		
		run();
	}
	
//______________________________________________________________________________
//	Accessor

	public function server_get() {
		return _oServer;
	}
	
//______________________________________________________________________________
//	Process
	
	public function run() {
		
		// TODO : stop?
		while( true ) {
			_oServer.socket_process();
			_oRoomManager.game_process();
		}
		trace('server terminated');
	}
	
//______________________________________________________________________________
//	Trigger
	
	public function trigger( oSource :IEventDispatcher ){
		
		// Collect client
		if( oSource == _oServer.onAnyOpen ) {
			trace('[NOTICE]:New client.');
		}
		
	}
}
