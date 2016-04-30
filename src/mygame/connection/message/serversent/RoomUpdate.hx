package mygame.connection.message.serversent;

import haxe.ds.StringMap;
import mygame.server.model.Room;
import mygame.client.model.UserInfo;

class RoomUpdate implements ILobbyMessage {
	public var aUser :Array<UserInfo>;
	public var iGameSpeed :Int;	//time ms
	
	public function new() {
		
		
	}
}

