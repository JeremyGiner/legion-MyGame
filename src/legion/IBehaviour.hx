package legion;

import legion.entity.Player;
import legion.Game;

interface IBehaviour {
	
	public function process() :Void;
	
	public function processName_get() :String;
}