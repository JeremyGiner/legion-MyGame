package trigger;

import trigger.ITrigger;

interface IEventDispatcher {
	public function attach( oTrigger :ITrigger ):Void;
	public function remove( oTrigger :ITrigger ):Void;
	
	public function event_get():Dynamic;
}