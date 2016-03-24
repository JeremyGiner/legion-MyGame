package trigger.eventdispatcher;

import trigger.EventDispatcher2;
import trigger.IEventDispatcher;
import trigger.ITrigger;


class EventDispatcherFunel<CEvent> extends EventDispatcher2<CEvent> implements IEventDispatcher implements ITrigger {

//______________________________________________________________________________
//	Constructor

//______________________________________________________________________________
//	Accessor

	
	public function link_add( oIEventDispatcher :IEventDispatcher ){
	
		oIEventDispatcher.remove( this );
		
		return this;
	}
	
	public function link_remove( oIEventDispatcher :IEventDispatcher ) {
		oIEventDispatcher.remove( this );
		
		return this;
	}
	

//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) {
		dispatch( oSource.event_get() );
	}
	


}