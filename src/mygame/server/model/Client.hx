package mygame.server.model;

import mygame.game.MyGame in Game;
import legion.entity.Player;
import websocket.php.SocketDistant in PHPWSClient;
import websocket.IMessage;
import mygame.connection.*;
import mygame.connection.message.*;
import websocket.Resource;

import trigger.*;
import trigger.eventdispatcher.*;

import haxe.Serializer;
import haxe.Unserializer;

/**
 * Wrap SocketDistant and assign it to a possible room slot.
 * Also serialise and unserialise message ( Assume that all incoming message 
 * have been serialized, watchout for error if not ). 
 * 
 * @author GINER Jérémy
 */
class Client extends PHPWSClient implements ITrigger {
	
	var _oMessageLast :IMessage;
	
	var _oRoom :Room = null;
	var _iSlotId :Int = -1;
	
	var _oMySerializer :MySerializer;
	//var _oMyUnSerializer :MyUnSerializer;
	
	//_____

//______________________________________________________________________________
//	Constructor
	
	public function new( oResource :Resource ){
		super( oResource );
		
		_oMySerializer = new MySerializer();
		_oMySerializer.useCache = true;
		//_oMyUnSerializer = new MyUnserializer();
	}
	
//______________________________________________________________________________
//	Accessor

	public function messageLast_get() { return _oMessageLast; }
	
	public function slotId_get() { return _iSlotId; }
	public function player_get() { return _oRoom.game_get().player_get(_iSlotId); }
	
	public function room_get() { return _oRoom; }
	public function room_set( oRoom :Room, iSlotId :Int ) { 
		_oRoom = oRoom; 
		_iSlotId = iSlotId;
	}
	
	

//______________________________________________________________________________
//	Modifier

	public function send( oMessage :IMessage ) {
		
		// Set relative (TODO : find a way to define this inside ReqPlayerInput, ResGameStepInput ....)
		Serializer.USE_CACHE = true;
		if ( Std.is( oMessage, ReqPlayerInput ) || Std.is( oMessage, ResGameStepInput ) )
			MySerializer._bUSE_RELATIVE = true;
		else
			MySerializer._bUSE_RELATIVE = false;
		
		// Serialize and send
		write( MySerializer.run(oMessage) );
	}
	override function _message_handle() {
		_oMessageLast = MyUnserializer.run( readResult_get(), game_get() );
		super._message_handle();
	}
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) {
		/*
		if( oSource == super.onMessage ) {
			_oMessageLast = MyUnserializer.run( super.readResult_get(), game_get() );
			onMessage.dispatch( this );	
		}
		
		if ( oSource == super.onClose ) {
			super = null;
			onClose.dispatch( this );
		}*/
	}
	
//______________________________________________________________________________
//	Shortcut

	public function game_get() {
		if ( _oRoom == null ) return null;
		return _oRoom.game_get();
	}

}