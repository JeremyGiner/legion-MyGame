package mygame.game.utils;

import haxe.ds.StringMap;
import legion.entity.Entity;
import mygame.game.MyGame;
import trigger.eventdispatcher.EventDispatcher;
import trigger.IEventDispatcher;
import trigger.ITrigger;

/**
 * ...
 * @author GINER Jérémy
 */
class EntityQuery implements ITrigger {

	var _oGame :MyGame;
	var _oFilter :StringMap<Dynamic>;
	
	var _aoEntity :List<Entity>;
	
	public function new( oGame :MyGame, oFilter :StringMap<Dynamic> ) {
		_oFilter = oFilter;
		_oGame = oGame;
		
	}
	
	public function list_get() {
		return _aoEntity;
	}
	
	function filter( oEntity :Entity ) :Bool {
		
		for( sKey in _oFilter.keys() )
			switch( sKey ) {
				case '_class' :
					if ( Std.is( oEntity, _oFilter.get( sKey ) ) )
						return true;
				default:
					return false;
			}
		return false;
	}
	
	public function trigger( oSource :IEventDispatcher ) {
		var oEntity :Entity = cast oSource.event_get();
		
		if ( !this.filter( oEntity ) )
			return;
		
		if ( oSource == _oGame.onEntityNew  )
			_aoEntity.push( oEntity );
			
		if( oSource == _oGame.onEntityDispose  )
			_aoEntity.remove( oEntity );
	}
}