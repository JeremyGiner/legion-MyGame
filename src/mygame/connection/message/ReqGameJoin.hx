package mygame.connection.message;

class ReqGameJoin implements ILobbyMessage {
	public var _iGameId :Int;
	public var _iSlotId :Int; //-1 : for any avaliable slot
	
	public function new( iGameId :Int, iSlotId :Int =-1 ) {
		_iGameId = iGameId;
		_iSlotId = iSlotId;
	}
	
	public function gameId_get() { return _iGameId; }
	public function slotId_get() { return _iSlotId; }
}