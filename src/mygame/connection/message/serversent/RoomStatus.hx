package mygame.connection.message.serversent;

import haxe.ds.StringMap;
import mygame.server.model.Room;

class RoomStatus implements ILobbyMessage {
	public var aUser :Array<StringMap<Dynamic>>;
	public var iGameSpeed :Int;	//time ms
	
	public function new( oRoom :Room ) {
		
		aUser = new Array<StringMap<Dynamic>>();
		iGameSpeed = Std.int( oRoom.gameSpeed_get() );
		
		var aPause = oRoom.pauseList_get();
		
		for ( i in 0...aPause.length ) {
			aUser[i] = new StringMap();
			aUser[i].set('name', 'player'+i );
			aUser[i].set('ready', aPause[i] );
			aUser[i].set('playerindex', i );
		}
	}
}