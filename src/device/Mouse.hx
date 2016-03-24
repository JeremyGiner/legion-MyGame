package legion.device;

import js.html.MouseEvent;

import legion.device.Device;
import js.html.EventTarget;
import trigger.*;
import trigger.eventdispatcher.*;

class Mouse implements ITrigger {

	public var onUpdate :EventDispatcherTree;
	
	public var onPress :EventDispatcherTree;
	public var onPressLeft :EventDispatcherTree;
	public var onPressMiddle :EventDispatcherTree;
	public var onPressRight :EventDispatcherTree;
	
	public var onRelease :EventDispatcherTree;
	public var onReleaseLeft :EventDispatcherTree;
	public var onReleaseMiddle :EventDispatcherTree;
	public var onReleaseRight :EventDispatcherTree;
	
	public var onMove :EventDispatcherTree;
	
	//_____
	
	var _x :Int;
	var _y :Int;
	var _abButtonState :Array<Bool>;
	
	var _JSClick :EventDispatcher;
	var _JSMouseUp :EventDispatcher;
	var _JSMouseDown :EventDispatcher;
	var _JSMouseMove :EventDispatcher;
	var _JSContextMenu :EventDispatcher;
	
	// TODO : clipboard?
	
//_____________________________________________________________________________
//	Constructor

	public function new( oEventTarget :EventTarget = null){
	
		_JSClick = new EventDispatcherJS( 'click', oEventTarget );
		_JSMouseUp = new EventDispatcherJS( 'mouseup', oEventTarget);
		_JSMouseDown = new EventDispatcherJS( 'mousedown', oEventTarget);
		_JSMouseMove = new EventDispatcherJS( 'mousemove', oEventTarget);
		_JSContextMenu = new EventDispatcherJS( 'contextmenu', oEventTarget);
		
		_JSClick.attach( this );
		_JSMouseUp.attach( this );
		_JSMouseDown.attach( this );
		_JSMouseMove.attach( this );
		_JSContextMenu.attach( this );
		
		_abButtonState = new Array<Bool>();
		
		onUpdate = new EventDispatcherTree(Device.onUpdate);
	
		onPress = new EventDispatcherTree(onUpdate);
		onPressLeft = new EventDispatcherTree(onPress);
		onPressMiddle = new EventDispatcherTree(onPress);
		onPressRight = new EventDispatcherTree(onPress);
		
		onRelease = new EventDispatcherTree(onUpdate);
		onReleaseLeft = new EventDispatcherTree(onRelease);
		onReleaseMiddle = new EventDispatcherTree(onRelease);
		onReleaseRight = new EventDispatcherTree(onRelease);
		
		onMove = new EventDispatcherTree(onUpdate);
		
		
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function x_get(){return _x;}
	public function y_get(){return _y;}
	
	public function buttonState_get( i :Int ){ return _abButtonState[i]; }
	
	public function leftButtonState_get(){ return buttonState_get(0); }
	public function middleButtonState_get(){ return buttonState_get(1); }
	public function rightButtonState_get(){ return buttonState_get(2); }
	
//_____________________________________________________________________________
//	Utils

	function _autoUpdate( oEvent :MouseEvent ){
		
		_x = oEvent.clientX;
		_y = oEvent.clientY;
		
		/* Event.button:
		 * 	[0] : left button
		 * 	[1] : middle button
		 * 	[2] : right button
		 */
		
		// Update buffer
		if( oEvent.type == 'mouseup' )
			_abButtonState[ oEvent.button ] = false;
		if( oEvent.type == 'mousedown' )
			_abButtonState[ oEvent.button ] = true;
		
		
		
		// Create event : mouse update
		switch( oEvent.type ){
			case 'mousedown' : 
				switch( oEvent.button ){
					case 0 : onPressLeft.dispatch( this );
					case 1 : onPressMiddle.dispatch( this );
					case 2 : onPressRight.dispatch( this );
				}
			case 'mouseup' : 
				switch( oEvent.button ){
					case 0 : onReleaseLeft.dispatch( this );
					case 1 : onReleaseMiddle.dispatch( this );
					case 2 : onReleaseRight.dispatch( this );
				}
			case 'mousemove' : onMove.dispatch( this );
		}
		
		
		// Intercept JS Event
		oEvent.preventDefault();
		oEvent.stopPropagation();
		oEvent.returnValue = false;
	}
	
//_____________________________________________________________________________
//	Trigger (Event Handler)

	public function trigger( oSource :Dynamic ){

		if( Std.is( oSource.event_get(), MouseEvent ) )
			_autoUpdate( cast oSource.event_get() );
	}
	
}