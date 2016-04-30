package trigger.eventdispatcher;

import trigger.EventDispatcher2;
import trigger.IEventDispatcher;
import trigger.ITrigger;


class EventDispatcherFunel<CEvent> extends EventDispatcher2<CEvent> implements IEventDispatcher implements ITrigger {

//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) {
		dispatch( oSource.event_get() );
	}
	


}