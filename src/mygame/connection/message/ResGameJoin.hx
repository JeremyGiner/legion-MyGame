package mygame.connection.message;

import mygame.game.MyGame;

class ResGameJoin implements ILobbyMessage {
	public var iGameId :Int;
	public var iSlotId :Int;
	public var oGame :MyGame;
	var _fSpeed :Float;
	
	public function new( fSpeed :Float ){
		_fSpeed = fSpeed;
	}
}