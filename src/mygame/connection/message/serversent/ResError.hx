package mygame.connection.message.serversent;
import mygame.server.model.Room;

class ResError implements ILobbyMessage {
	
	var _iId :Int;
	var _sMessage :String;
	
	public function new( iId :Int, sMessage :String ) {
		_iId = iId;
		_sMessage = sMessage;
	}
	
	public function id_get() {
		return _iId;
	}
	
	public function message_get() {
		return _sMessage;
	}
}