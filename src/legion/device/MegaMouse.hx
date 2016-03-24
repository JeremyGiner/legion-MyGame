package legion.device;

import js.html.MouseEvent;
import js.html.CustomEvent;
import js.html.WheelEvent;
import trigger.eventdispatcher.*;
import js.html.EventTarget;

class MegaMouse extends Mouse {
	
	var _wheel :Float;
	
	public var onWheel :EventDispatcherTree;
	
	var EDWheel :EventDispatcherJS;// =  { new EventDispatcherJS('DOMMouseScroll'); };
	
//_____________________________________________________________________________
// Constructor

	override public function new( oEventTarget :EventTarget = null){
		super( oEventTarget );
		
		onWheel = new EventDispatcherTree( onUpdate );
		
		//TODO : compatibility check
		
		EDWheel = new EventDispatcherJS('wheel', oEventTarget);	// Recent browser only
		
		
		EDWheel.attach( this );	// Firefox
		
	}
	
//_____________________________________________________________________________
// Accessor
	
	public function wheel_get(){return _wheel;}

//_____________________________________________________________________________

	function _wheelupdate( oEvent :CustomEvent ){
		
		var event :CustomEvent = cast oEvent;
		
		// For mozilla or chrome
		if( Reflect.hasField( event, 'wheelDelta') )
			_wheel = untyped - event.wheelDelta / 40;	
		else
			_wheel = untyped event.deltaY;
		_wheel = cast -_wheel/3;
		
		onWheel.dispatch( this );
	}
	
//_____________________________________________________________________________
//	Trigger

	override public function trigger( oSource :Dynamic ){
		if( oSource == EDWheel )
			_wheelupdate( oSource.event_get() );
		else
			super.trigger( oSource );
	}
	
}