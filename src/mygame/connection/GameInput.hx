package mygame.connection;

import legion.PlayerInput;

class GameInput {
	public var iLoopId :Int;
	public var aoPlayerInput :List<PlayerInput>;
	
	var _liPlayerInputIndexTemp : List<Int>;
	
//______________________________________________________________________________
	
	public function new() {
		aoPlayerInput = new List<PlayerInput>();
	}
	
//______________________________________________________________________________
	
}