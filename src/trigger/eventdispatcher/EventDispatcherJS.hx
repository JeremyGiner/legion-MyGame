package trigger.eventdispatcher;

/**
 * @author GINER Jérémy
 * @see https://developer.mozilla.org/en-US/docs/Web/Events
 */

import trigger.eventdispatcher.EventDispatcher;
import js.html.Event in EventJS;
import js.html.EventTarget;

class EventDispatcherJS extends EventDispatcher {

	private var _sType :String;		//Exemple : "click", ...
	
	static public var onClick :EventDispatcherJS = { new EventDispatcherJS('click'); };
	static public var onMouseUp :EventDispatcherJS = { new EventDispatcherJS('mouseup'); };
	static public var onMouseDown :EventDispatcherJS = { new EventDispatcherJS('mousedown'); };
	static public var onMouseMove :EventDispatcherJS = { new EventDispatcherJS('mousemove'); };
	static public var onContextMenu :EventDispatcherJS = { new EventDispatcherJS('contextmenu'); };
	
//_____________________________________________________________________________
//	Constructor

	public function new( sType :String, oEventTarget :EventTarget = null ){
		super();
		_sType = sType;
		if( oEventTarget == null)
			oEventTarget = js.Browser.window;
		oEventTarget.addEventListener( _sType, dispatch );
	}
	
}