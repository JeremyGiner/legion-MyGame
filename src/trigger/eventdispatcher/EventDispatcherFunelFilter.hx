package trigger.eventdispatcher;

import trigger.EventDispatcher2;
import trigger.IEventDispatcher;
import trigger.ITrigger;
import utils.IValidator;


class EventDispatcherFunelFilter<CEvent> extends EventDispatcher2<CEvent> implements IEventDispatcher implements ITrigger {

	var _oFilter :IValidator<CEvent>;
	
//______________________________________________________________________________
//	Contructor

	public function new( oFilter :IValidator<CEvent> ) {
		_oFilter = oFilter;
	}
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) {
		if ( !_oFilter.validate( cast oSource.event_get() ) )
			return;
		dispatch( oSource.event_get() );
	}
	


}