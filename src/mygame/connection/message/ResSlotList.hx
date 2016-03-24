package mygame.connection.message;

import mygame.game.MyGame;

class ResSlotList implements ILobbyMessage {
	public var liGameId :List<Int>;
	
	public function new(){
		liGameId = new List<Int>();
	}
}