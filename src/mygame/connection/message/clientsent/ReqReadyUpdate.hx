package mygame.connection.message.clientsent;

class ReqReadyUpdate implements ILobbyMessage {
	
	var _bReady :Bool;
	
	public function new( bReady :Bool ) {
		_bReady = bReady;
	}
	
	public function ready_get() {
		return _bReady;
	}
	
}