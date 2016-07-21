package mygame.game.ability;
import haxe.ds.StringMap;
import trigger.eventdispatcher.EventDispatcher;

/**
 * todo : sort modifier by priority
 * @author GINER Jérémy
 */
class Attribute<CValue> {

	var _oValueBase :CValue;
	var _lModifier :List<AttriModifier<CValue>>;
	
	var _bCacheNeedUpdate :Bool;
	var _oValueCache :CValue;
	
	//var onUpdate :EventDispatcher<EventStatUpdate>;
	
//_____________________________________________________________________________
//	Constructor
	
	public function new( oValueBase :CValue ) {
		
		valueBase_set( oValueBase );
	}
	
//_____________________________________________________________________________
//	Accessor

	public function value_get() {
		if ( _bCacheNeedUpdate )
			_valueCache_update();
		return _oValueCache;
	}
	
//_____________________________________________________________________________
//	Modifier
	
	public function valueBase_set( oValueBase :CValue ) {
		_oValueBase = oValueBase;
		_bCacheNeedUpdate = true;
	}

	public function modifier_add( oModifier :AttriModifier<CValue> ) {
		_bCacheNeedUpdate = true;
		_lModifier.add( oModifier );
	}
	public function modifier_remove( oModifier :AttriModifier<CValue> ) {
		_bCacheNeedUpdate = true;
		_lModifier.remove( oModifier );
	}
	
//_____________________________________________________________________________
//	Sub-routine
	
	function _valueCache_update() {
		var v = _oValueBase;
		for ( oModifier in _lModifier ) {
			v = oModifier.get( v );
		}
		_bCacheNeedUpdate = false;
		_oValueCache = v;
	}
	
	
}

class AttriModifier<CClass> {
	public function new( sField :String, oValue :? ) {
		
	}
	
	public function get( oValue :CClass ) {
		return oValue;
	}
}