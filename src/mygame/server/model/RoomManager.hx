package mygame.server.model;

import haxe.ds.IntMap;

import mygame.connection.GameInput;
import legion.PlayerInput;

import mygame.game.MyGame;
import trigger.eventdispatcher.*;


class RoomManager {
	
	var _moRoom :IntMap<Room>;
	var _moGameInput :IntMap<GameInput>;

	static var _iIdAutoIncrement :Int=0;
	
	public var onAnyProcessStart :EventDispatcher;
	public var onAnyRoomUpdate :EventDispatcherFunel<Room>;
	
//______________________________________________________________________________
//	Constructor

	public function new() {
		_moRoom = new IntMap<Room>();
		_moGameInput = new IntMap<GameInput>();
		
		onAnyProcessStart = new EventDispatcher();
		onAnyRoomUpdate = new EventDispatcherFunel<Room>();
	}

//______________________________________________________________________________
//	Accessor
	

	
	public function game_get( iGameId :Int ) {
		return _moRoom.get( iGameId );
	}
	
	public function roomList_get() {
		return _moRoom;
	}
	
	public function room_get( iGameId :Int ) {
		return _moRoom.get( iGameId );
	}
	
//_____
	
	public function client_get( iMatchId :Int, iSlotId :Int ) :Client {
		// Get match
		var oMatch = game_get( iMatchId );
		
		// Check if match exist
		if( oMatch == null ) return null;
		
		//Return client
		return oMatch.client_get( iSlotId );
	}
	
	public function gameList_get() { return _moRoom; }
	
	public function gameInput_get( iGameId :Int ) {
		return _moGameInput.get( iGameId );
	}
//______________________________________________________________________________
//	Modifier

	public function game_create() {
		var oRoom = new Room( new MyGame() );
		_moRoom.set( _iIdAutoIncrement, oRoom );
		_iIdAutoIncrement++;
		
		oRoom.onUpdate.attach( onAnyRoomUpdate );
	}
	
//______________________________________________________________________________
//	Process

	public function game_process() {
		// TODO : check timer for game speed
		for( oRoom in _moRoom ) {
			if ( oRoom.timerExpire_check() && !oRoom.paused_get() ) {
				
				
				onAnyProcessStart.dispatch( oRoom );
				oRoom.process();
			}
		} 
	}
	
	public function gameInput_add( iGameId :Int, oPlayerInput :PlayerInput ) {
	
		// Check game exist
			var oGame = game_get_byId( iGameId );
			if( oGame == null ) { throw('Game doesnt exist '); return; }
			
		// Dispatch
			//oPlayerInput.exec();
	
		// Log
			var oGameInput = _moGameInput.get( iGameId );
			if( oGameInput == null ) {
				oGameInput = new GameInput();
				_moGameInput.set( iGameId, oGameInput );
			} else {
				oGameInput.aoPlayerInput.push( oPlayerInput );
			}
	}
	
//______________________________________________________________________________
//	Shortcut

	public function game_get_byId( iKey :Int ) {
		return _moRoom.get( iKey );
	}
}