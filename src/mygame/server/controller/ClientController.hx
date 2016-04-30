package mygame.server.controller;

import mygame.connection.message.serversent.ResError;
import mygame.connection.message.serversent.RoomUpdate;
import mygame.connection.ServerMessageFactory;
import mygame.server.model.RoomManager;
import mygame.server.model.Client;
import trigger.*;
import mygame.connection.message.*;
import mygame.connection.message.clientsent.ReqReadyUpdate;
import websocket.MessageComposite;

import mygame.server.model.Room;

class ClientController implements ITrigger {
	
	var _oRoomManager :RoomManager;
	var _oParent :Controller;
	
//______________________________________________________________________________
//	Constructor

	public function new( oParent :Controller, oRoomManager :RoomManager ) {
		_oParent = oParent;
		_oRoomManager = oRoomManager;
		
		_oParent.server_get().onAnyMessage.attach( this );
		_oParent.server_get().onAnyClose.attach( this );
		
		_oRoomManager.onAnyProcessStart.attach( this );
		_oRoomManager.onAnyRoomUpdate.attach( this );
	}
	
//______________________________________________________________________________
//	Message handler

	function message_handle( oClient :Client ) {
		var oMessage = oClient.messageLast_get();
		
		switch( Type.getClass( oMessage ) ) {
			case ReqSlotList :
				trace('requesting game list');
				
				var oRespond = new ResSlotList();
				
				for( iKey in _oRoomManager.gameList_get().keys() ) {
					oRespond.liGameId.push( iKey );
				}
				oClient.send( oRespond );
			
			//case ResGameCreate :
				// check creation limit
				// gamemanager create new game
			
			case ReqShutDown :
				trace('Closing by command of a client');
				Sys.exit( 0 );
				
			case ReqGameJoin :

				trace('[NOTICE]:requesting access to game #'+cast(oMessage,ReqGameJoin).gameId_get());
				var iRoomId = cast(oMessage,ReqGameJoin).gameId_get();
				var iSlotId = cast(oMessage,ReqGameJoin).slotId_get();
				
				// Leave previous room
				if( oClient.room_get() != null ) {
					oClient.room_get().slot_leave( oClient );
				}
				
				// Get room
				var oRoom = _oRoomManager.room_get( iRoomId );
				if( oRoom == null ) {
					trace('[ERROR]:Room #'+iRoomId+' does not exist.');
					return;
				}
				
				// Attach slot to client
				if ( iSlotId == -1 )
					iSlotId = oRoom.slotFreeAny_get();
				if ( iSlotId == null ) 
					throw('slot :not any available');
				var iSlotAvailable = oRoom.slot_occupy( oClient, iSlotId );
				if( iSlotAvailable == null ) {
					trace('[ERROR]:slot occupation fail.');
					return;
				}
				
				trace('Occupied slot #'+iSlotAvailable );
				trace('Room client Q = '+oRoom.clientList_get().length );
				
				// Sending respond
				var oRespond = ServerMessageFactory.resGameJoin_create( oRoom, iSlotAvailable );
				trace(oRespond);
				oClient.send( oRespond );
				
				// Send Room status
				var oRoomUpdate = oRespond.oRoomUpdate;
				for ( oClientTmp in oRoom.clientList_get() )
					if( oClient != oClientTmp )
						oClientTmp.send( oRoomUpdate );
				
			case ReqPlayerInput :
				
				// Check room
				if( oClient.room_get() == null ) {
					trace('[ERROR]: input send to no room');
					return;
				}
				
				// TODO : check slot
				
				// Register input
				oClient.room_get().gameAction_add(
					cast(oMessage,ReqPlayerInput).action_get( oClient.player_get() )
				);
				
			case ReqGameQuit :
				
				if ( oClient.room_get() == null ) {
					trace('[ERROR] : Client trying to leave a null room');
					return;
				}
					
				//Detach slot from client
				oClient.room_get().slot_leave( oClient );
				oClient.room_set( null, -1 );
				
			case ReqReadyUpdate :
				
				var oRoom = oClient.room_get();
				
				if ( oRoom == null )
					oClient.send( new ResError( 1, 'Trying to update ready status while not in room') );
				
				oRoom.clientReady_update( 
					oClient, 
					cast(oMessage, ReqReadyUpdate).ready_get() 
				);	// should trigger an update event
			
			default :
				trace('[ERROR]:unknow command/respond from client:'+oMessage);
		}
	}
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ){

		
		//_____________________________
		//	Client Event
		
		if( oSource == _oParent.server_get().onAnyClose ) {
		
			// leave slot
			var oClient :Client = cast oSource.event_get();
			var oRoom = oClient.room_get();
			
			// No room no worry
			if ( oRoom == null ) 
				return;
			
			// Update room
			oRoom.slot_leave( oClient );
		
			// Send Room status
			for( oClient in oRoom.clientList_get() )
				oClient.send( ServerMessageFactory.roomUpdate_create( oRoom ) );
		}
		
		if( oSource == _oParent.server_get().onAnyMessage ) {
			message_handle( cast oSource.event_get() );
		}
		
		//_____________________________
		//	Room event
		
		if( oSource == _oRoomManager.onAnyProcessStart ) {
			var oRoom :Room = cast oSource.event_get();
			
			// Send game inputs
				// Create message
				var oMessage = new ResGameStepInput( 
					oRoom.game_get().loopId_get(), 
					oRoom.gameActionList_get()
				);
			//trace('[NOTICE]:sending '+oRoom.gameActionList_get().length+' input to '+oRoom.clientList_get().length+' client.' );
				// Send to each client inside the room
				for( oClient in oRoom.clientList_get() ) {
					//trace('[NOTICE]:Game input send.');
					oClient.send( oMessage );
				}
			
		}
		if ( oSource == _oRoomManager.onAnyRoomUpdate ) {
			var oRoom :Room = cast _oRoomManager.onAnyRoomUpdate.event_get();
			var oMessage = ServerMessageFactory.roomUpdate_create( oRoom );
			for( oClient in oRoom.clientList_get() ) {
				oClient.send( oMessage );
			}
		}
	}
}