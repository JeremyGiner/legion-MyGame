package mygame.connection;

class GameSlot {
	public var iGameId :Int;
	public var aiPlayerSlot :Array<Int>;
	public var iSpectatorSlot :Array<Int>;
	
	public function new() {}
	
	public function playerSlotFree_check() :Bool { return true; }
	public function spectatorSlotFree_check() :Bool { return true; }
	
	//public function playerSlotOccupied() :Int { return aiPlayerSlot }
	public function playerSlotMax() :Int { return aiPlayerSlot.length; }
}