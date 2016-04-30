package mygame.client.model;

import js.Browser;
import js.Lib;
import mygame.client.model.RoomInfo;
import mygame.game.MyGame;
import mygame.game.entity.Player;
import mygame.trigger.eventdispatcher.*;
import legion.device.MegaMouse in Mouse;
import legion.device.Keyboard;

class Model {

	var _oGame :MyGame = null;
	var _oPlayer :Player = null;
	var _oGUI :GUI = null;
	
	var _oMouse :Mouse;
	var _oKeyboard :Keyboard;
	
	var _oConnection :Connection = null;
	
	var _oRoomInfo :RoomInfo = null;
	
//______________________________________________________________________________
//	Constructor

	public function new() {
		
		//onConnection = new EventDispatcher();
		
		//_oMouse = new Mouse( _oGameView.renderer_get().domElement );
		_oMouse = new Mouse( Browser.document.getElementById('MyCanvas') );
		_oKeyboard = new Keyboard();
	}
	
//______________________________________________________________________________
//	Accessor
	
	public function game_get() { return _oGame; }
	
	public function playerLocal_get() { return _oPlayer; }
	
	public function GUI_get() { return _oGUI; }
	
	public function connection_get() { return _oConnection; }
	
	public function mouse_get() { return _oMouse; }
	
	public function keyboard_get() { return _oKeyboard; }
	
	public function roomInfo_get() {
		return _oRoomInfo;
	}
	
	public function userInfoCurrent_get() {
		for ( oUserInfo in _oRoomInfo.userInfoList_get() ) {
			if ( oUserInfo.playerId == _oPlayer.playerId_get() )
				return oUserInfo;
		}
		throw('Weird');
	}
	
//______________________________________________________________________________
//	Modifier

	public function game_set( oGame :MyGame, iPlayerKey :Int, oRoomInfo :RoomInfo ) { 
		//TODO : check oGame
		_oGame = oGame;
		_oRoomInfo = oRoomInfo;
		_oPlayer = _oGame.player_get( iPlayerKey );
		if( _oPlayer == null ) trace('[ERROR]:invalid player id');//throw('[ERROR]:invalid player id');
		_oGUI = new GUI( _oGame );
		return ; 
	}
	
	public function roomInfo_set( oRoomInfo :RoomInfo ) {
		_oRoomInfo = oRoomInfo;
	}

//______________________________________________________________________________
//	Connection

	public function connection_new() {
		if( _oConnection == null )
			_oConnection = new Connection( this );
	}
	
	public function disconnect() {
		trace( 'Disconnecting..' );
		_oConnection.close();
	}
	
}