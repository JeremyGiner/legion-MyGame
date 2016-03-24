package legion;

import legion.entity.Player;

class PlayerInput {
	
	private var _oPlayer :Player;
	
	private function new( oPlayer :Player ) {
		_oPlayer = oPlayer;
	}
	
//______________________________________________________________________________
// Utils

	public function exec() {

	}
	
	public function check() {
		return true;
	}
	
}