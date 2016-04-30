package mygame.client.model;
import haxe.ds.StringMap;
import mygame.connection.message.serversent.RoomUpdate;
import trigger.eventdispatcher.EventDispatcher;
import mygame.client.model.UserInfo;

/**
 * Room view by a client
 * 
 * @author GINER Jérémy
 */
class RoomInfo {

	var _aUserInfo :Array<UserInfo>;
	public var onUpdate :EventDispatcher;
	
//_____________________________________________________________________________
//	Contrustor
	
	function new() {
		_aUserInfo = null;
		onUpdate = new EventDispatcher();
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function userInfoList_get() :Array<UserInfo> {
		return _aUserInfo;
	}
	
	public function isPaused() {
		for ( oUserInfo in _aUserInfo )
			if ( oUserInfo.ready == false )
				return true;
		return false;
	}
	
	
	
//_____________________________________________________________________________
//	Modifier
	
	public function update( oMessage :RoomUpdate ) {
		_aUserInfo = oMessage.aUser;
		onUpdate.dispatch( this );
	}

//_____________________________________________________________________________
//	Factory
	
	/**
	 * Create default room info
	 * 1v1 human vs AI
	 */
	static public function default_create() {
		var o = new RoomInfo();
		o._aUserInfo = [
			{
				name: 'Player 0',
				ready: true,
				ai: false,
				playerId: 0
			},
			{
				name: 'Nemesis',
				ready: true,
				ai: true,
				playerId: 1
			},
		];
		return o;
	}
	
	static public function online_create( oMessage :RoomUpdate ) {
		var o = new RoomInfo();
		o._aUserInfo = oMessage.aUser;
		
		return o;
	}
	
}
