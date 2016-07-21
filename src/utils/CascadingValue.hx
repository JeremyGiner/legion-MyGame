package utils;
import trigger.EventDispatcher2;
import trigger.IEventDispatcher;
import trigger.ITrigger;

/**
 * ...
 * @author GINER Jérémy
 */
class CascadingValue<C> implements ITrigger {

	var _aDispatcher :Array<IEventDispatcher>;
	var _oValue :C;
	var _bUpToDate :Bool;
	
	public var onUpdate :EventDispatcher2<CascadingValue<C>>;
	
	function new( aDispatcher :Array<IEventDispatcher> ) {
		_aDispatcher = aDispatcher;
		_bUpToDate = false;
		
		for ( o in _aDispatcher )
			o.attach( this );
		
		onUpdate = new EventDispatcher2<CascadingValue<C>>();
	}
	
	public function get() :C {
		if ( !_bUpToDate ) {
			
			var oValueOld = _oValue;
			
			_update();
			
			_bUpToDate = true;
		}
		return _oValue;
	}
	
	function _update() {
		throw('abstract');
	}
	
	public function trigger( oSource :IEventDispatcher ) {
		_bUpToDate = false;
		//if ( _oValue != oValueOld )
		onUpdate.dispatch( this );
	}
	
	public function dispose() {
		for ( oDispatcher in _aDispatcher )
			oDispatcher.remove( this );
	}
	
}