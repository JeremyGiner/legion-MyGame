package legion.device;

import haxe.ds.StringMap;
import js.html.KeyboardEvent;

import trigger.*;
import trigger.eventdispatcher.*;

import legion.device.Device;

class Keyboard implements ITrigger {

	public var onUpdate :EventDispatcherTree;
	public var onPress :EventDispatcherTree;
	public var onRelease :EventDispatcherTree;
	
	private var _abKeyState :StringMap<Bool>;
	private var _lastModifiedKey :String;
	
	// TODO : clipboard?
	
//_____________________________________________________________________________
//	Constructor
	
	public function new(){
	
		//super();
		_abKeyState = new StringMap<Bool>();
		
		// Init event listener
		onUpdate = new EventDispatcherTree(Device.onUpdate);
		onPress = new EventDispatcherTree(onUpdate);
		onRelease = new EventDispatcherTree(onUpdate);
		
		// JS trigger
		//TOOD : store in vars
		new EventDispatcherJS('keydown').attach( this );
		new EventDispatcherJS('keyup').attach( this );
		//new EventDispatcherJS('keypress').attach( this );
		
		//js.Lib.alert("key uoadte");
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function keyState_get( s :String ){ return _abKeyState.get(s); }
	public function keyTrigger_get(){ return _lastModifiedKey; }
	
//_____________________________________________________________________________

	
	private function _autoUpdate( oEvent :KeyboardEvent ){
		
		// SCR : https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent
		//TODO : use event.key
		_lastModifiedKey = oEvent.key;

		// Update and dispatch
		switch( oEvent.type ) {
			case 'keydown' :
				if( _abKeyState.get( _lastModifiedKey ) != true ) {
					_abKeyState.set( _lastModifiedKey, true );
					onPress.dispatch( this );
				} //else it's a repeat
			case 'keyup' :
				_abKeyState.set( _lastModifiedKey, false );
				onRelease.dispatch( this );
		}
		
		
			
		//oEvent.preventDefault();
		//oEvent.stopPropagation();
		//oEvent.returnValue = false;
	}
	
	
//_____________________________________________________________________________

	public function trigger( oSource :IEventDispatcher ){

		if( Std.is( oSource.event_get(), KeyboardEvent )  )
			_autoUpdate( oSource.event_get() );
		
		
	}
}