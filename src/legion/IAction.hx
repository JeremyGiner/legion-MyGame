package legion;

import legion.entity.Player;
import legion.Game;

interface IAction<CGame:Game> {
	
	public function exec( oGame :CGame ) :Void;
	public function check( oGame :CGame ) :Bool;
}