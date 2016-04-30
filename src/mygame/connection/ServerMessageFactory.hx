package mygame.connection;

import mygame.client.model.UserInfo;
import mygame.connection.message.ResGameJoin;
import mygame.connection.message.serversent.RoomUpdate;
import mygame.server.model.Room;

/**
 * ...
 * @author GINER Jérémy
 */
class ServerMessageFactory {

	function new() {
		
	}
	
	static public function resGameJoin_create( oRoom :Room, iSlotId :Int ) :ResGameJoin {
		var o = new ResGameJoin();
		o.iGameId = oRoom.id_get();
		o.iSlotId = iSlotId;
		o.oGame = oRoom.game_get();
		o.oRoomUpdate = roomUpdate_create( oRoom );
		return o;
	}
	
	static public function roomUpdate_create( oRoom :Room ) :RoomUpdate {
		var oRoomUpdate = new RoomUpdate();
		oRoomUpdate.aUser = new Array<UserInfo>();
		
		var aPause = oRoom.pauseList_get();
		for ( i in 0...aPause.length ) {
			oRoomUpdate.aUser[i] = {
				name: 'player' + i,
				ready: aPause[i],
				ai: false,
				playerId: i
			};
		}
		oRoomUpdate.iGameSpeed = Std.int( oRoom.gameSpeed_get() );
		return oRoomUpdate;
	}
	
}