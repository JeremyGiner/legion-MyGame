package trigger;

class EventDispatcherTree<CEvent> extends EventDispatcher2<CEvent> {

	var _oParent :EventDispatcher2<CEvent>;
	
//______________________________________________________________________________
//	Constructor

	override public function new( oParent :EventDispatcher2<CEvent> ){
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

//______________________________________________________________________________

	// 
	override public function source_check( oSource :EventDispatcher2<Dynamic> ) {
		if ( oSource == this ) return true;
		return _oParent.source_check( oSource );
	}
	
	/*
	TODO :
	@:op( A == B )
	public function test( d :Dynamic ) {
		
	}
	*/
}