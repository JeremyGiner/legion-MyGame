package mygame.connection.message;

import legion.IAction;

class ResGameStepInput implements IGameMessage {
	var _iLoopId :Int;
	var _loInput :List<IAction<Dynamic>>;
	
	public function new( iLoopId :Int, loInput :List<IAction<Dynamic>> ){
		_iLoopId = iLoopId;
		_loInput = loInput;
	}
	
	public function loopId_get() { return _iLoopId; }
	public function inputList_get() { return _loInput; }
}