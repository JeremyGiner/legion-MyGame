package mygame.connection.message;

import mygame.game.action.IAction;

import space.Vector3;
import mygame.game.action.UnitDirectControl;

class ReqPlayerInput implements IGameMessage {
	
	var _oAction :IAction;
	
	public function new( oAction :IAction ) {
		_oAction = oAction;
	}
	
	public function action_get( oPlayer ) :IAction { 
		return _oAction;
	}
	
}