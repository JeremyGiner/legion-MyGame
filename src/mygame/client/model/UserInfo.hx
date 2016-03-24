package mygame.client.model;
import mygame.connection.message.serversent.RoomStatus;
/**
 * Room view by a client
 * 
 * @author GINER Jérémy
 */
class UserInfo {

	var _sName :String;
	var _bReady :Bool;
	var _iPlayerIndex :Int;
	
	public function new( oMessage :RoomStatus, iIndex :Int ) {
		var msInfo = oMessage.aUser[ iIndex ];
		
		_sName = msInfo.get('name');
		_bReady = msInfo.get('ready');
		_iPlayerIndex = msInfo.get('playerindex');
	}
	
	public function ready_get() {
		return _bReady;
	}
	
	public function name_get() {
		return _sName;
	}
	
	public function playerIndex_id() {
		return _iPlayerIndex;
	}
	
}