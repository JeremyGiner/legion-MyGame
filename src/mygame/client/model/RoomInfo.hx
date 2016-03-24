package mygame.client.model;
import haxe.ds.StringMap;
import mygame.connection.message.serversent.RoomStatus;
import trigger.eventdispatcher.EventDispatcher;

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
	
	public function new( oMessage :RoomStatus ) {
		
		onUpdate = new EventDispatcher();
		
		update( oMessage );
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function userInfoList_get() :Array<UserInfo> {
		return _aUserInfo;
	}
	
//_____________________________________________________________________________
//	Modifier
	
	public function update( oMessage :RoomStatus ) {
		_aUserInfo = new Array<UserInfo>();
		for( i in 0...oMessage.aUser.length )
			_aUserInfo.push( new UserInfo(oMessage, i) );
			
		onUpdate.dispatch( this );
	}
	
}