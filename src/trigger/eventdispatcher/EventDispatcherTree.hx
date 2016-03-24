package trigger.eventdispatcher;

import trigger.eventdispatcher.EventDispatcher;

class EventDispatcherTree extends EventDispatcher {

	private var _oParent :EventDispatcher;
	
//______________________________________________________________________________
//	Constructor

	override public function new( oParent :EventDispatcher ){
		super();
		_oParent = oParent;
	}
	
//______________________________________________________________________________

	override public function dispatch( ?oEvent :Dynamic ){
		
		// Dispatch to directly attached triggers
		super.dispatch( oEvent );
	
		// Dispatch to parent's triggers
		if( _oParent != null )
			_oParent.dispatch( oEvent );
			/*for( oTrigger in _oParent._aoTrigger ){
				oTrigger.trigger( this );
			}*/
			
		return this;
	}
	/*
	TODO :
	@:op( A == B )
	public function test( d :Dynamic ) {
		
	}
	*/
}