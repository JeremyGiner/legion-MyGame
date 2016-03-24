package trigger;

import trigger.IEventDispatcher;
import trigger.ITrigger;


class EventDispatcher2<CEvent> implements IEventDispatcher {

	var _aoTrigger : Array<ITrigger>;
	var _oEventCurrent :CEvent;

//______________________________________________________________________________
//	Constructor

	public function new(){
		_aoTrigger = new Array<ITrigger>();
	}

//______________________________________________________________________________
//	Accessor

	public function attach( oITrigger :ITrigger ){
	
		if( oITrigger == null ) throw '[ERROR]:trigger is null';
	
		_aoTrigger.push( oITrigger );
		
		//return this;
	}
	
	public function remove( oITrigger :ITrigger ){
		_aoTrigger.remove( oITrigger );
		
		//return this;
	}
	
	public function event_get() :CEvent { return _oEventCurrent; }

//______________________________________________________________________________

	public function dispatch( ?oEvent :Dynamic ){
		_oEventCurrent = oEvent;
		for( oTrigger in _aoTrigger ){
			oTrigger.trigger( this );
		}
		
		return this;
	}
	
//______________________________________________________________________________

	
	public function source_check( oSource :EventDispatcher2<Dynamic> ) :Bool {
		if ( oSource == this ) return true;
		return false;
	}
}