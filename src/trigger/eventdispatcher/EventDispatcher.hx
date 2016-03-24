package trigger.eventdispatcher;

import trigger.IEventDispatcher;
import trigger.ITrigger;


class EventDispatcher implements IEventDispatcher {

	private var _aoTrigger : Array<ITrigger>;
	private var _oEventCurrent :Dynamic;

//______________________________________________________________________________
//	Constructor

	public function new(){
		_aoTrigger = new Array<ITrigger>();
	}

//______________________________________________________________________________
//	Accessor

	public function attach( oITrigger :ITrigger ){
	
		//if( oITrigger == null ) throw 'Error : not a trigger';
	
		_aoTrigger.push( oITrigger );
		
		//return this;
	}
	
	public function remove( oITrigger :ITrigger ){
		_aoTrigger.remove( oITrigger );
		
		//return this;
	}
	
	public function event_get(){ return _oEventCurrent; }

//______________________________________________________________________________

	public function dispatch( ?oEvent :Dynamic ){
		_oEventCurrent = oEvent;
		for( oTrigger in _aoTrigger ){
			oTrigger.trigger( this );
		}
		
		return this;
	}
}