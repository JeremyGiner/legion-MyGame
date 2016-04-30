package mygame.connection.message;

import mygame.connection.message.serversent.RoomUpdate;
import mygame.game.MyGame;
import websocket.IMessage;

class ResGameJoin implements ILobbyMessage {
	public var iGameId :Int;
	public var iSlotId :Int;
	public var oGame :MyGame;
	public var oRoomUpdate :RoomUpdate;
	
	
	public function new(){
		
	}
}