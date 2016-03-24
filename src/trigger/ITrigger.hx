package trigger;

import trigger.IEventDispatcher;

interface ITrigger {

	public function trigger( oSource :IEventDispatcher ) :Void;
	
	//TODO : public function dispose():Void;

//______________________________________________________________________________
//	Shortcut

	//public function listen( oSource :IEventDispatcher ):Void;
}