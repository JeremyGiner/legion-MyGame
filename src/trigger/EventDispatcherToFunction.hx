package trigger;

import trigger.IEventDispatcher;
import trigger.ITrigger;


class EventDispatcherToFunction<CEvent> {

	var _aoTrigger :Array<CEvent->Void>;

//______________________________________________________________________________
//	Constructor

	public function new(){
		_aoTrigger = new Array<CEvent->Void>();
	}

//______________________________________________________________________________
//	Accessor

	public function attach( p :CEvent->Void ) {
	
		_aoTrigger.push( p );
		
		return this;
	}
	
	
//______________________________________________________________________________

	public function dispatch( oEvent :CEvent ){
		for( oTrigger in _aoTrigger ){
			oTrigger(oEvent);
		}
		
		return this;
	}
}