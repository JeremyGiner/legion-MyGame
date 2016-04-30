package legion;

import haxe.ds.StringMap;
import legion.ability.IAbility;
import legion.entity.Entity;
import legion.entity.Player;
import trigger.eventdispatcher.EventDispatcher;
import trigger.eventdispatcher.EventDispatcherFunel;
import trigger.EventDispatcher2;
import utils.Disposer;

/**
 * ...
 * @author GINER Jérémy
 */
class Game {
	
	var _aoEntity :Array<Entity>;
	var _iIdAutoIncrement :Int = 0;
	var _mSingleton :StringMap<Dynamic>;
	
	public var onEntityNew :EventDispatcher2<Entity>;
	public var onEntityDispose :EventDispatcherFunel<Entity>;
	public var onEntityAbilityAdd :EventDispatcherFunel<EventEntityAbility>;
	public var onEntityAbilityRemove :EventDispatcherFunel<EventEntityAbility>;
	
	//public var onAbilityDispose :EventDispatcher2<IAbility>;
	
	public static var onAnyStart :EventDispatcher = {new EventDispatcher();};
	
//______________________________________________________________________________
//	Constructor

    function new() {
        _aoEntity = new Array<Entity>();
		_mSingleton = new StringMap<Dynamic>();
        
        onEntityNew = new EventDispatcher2<Entity>();
        onEntityDispose = new EventDispatcherFunel<Entity>();
        onEntityAbilityAdd = new EventDispatcherFunel<EventEntityAbility>();
        onEntityAbilityRemove = new EventDispatcherFunel<EventEntityAbility>();
    }
	
//______________________________________________________________________________
//	Accessor
	
	public function entity_get( i :Int) {
		for ( oEntity in _aoEntity )
			if ( oEntity.identity_get() == i )
				return oEntity;
		return null;
	}
	
	public function entity_get_all() { return _aoEntity; }
	
	public function query_get<C>( oClass :Class<C> ) :C {
		return _mSingleton.get( Type.getClassName( oClass ) );
	}

	public function singleton_get<C>( oClass :Class<C> ) :C {
		return _mSingleton.get( Type.getClassName( oClass ) );
	}
	
	
	public function action_run( oAction :IAction<Dynamic> ) :Bool { throw('I am abstract'); return true;  }
	
//______________________________________________________________________________
//	Modifier
	
	public function entity_add( oEntity :Entity ) {
		oEntity.identity_set( _iIdAutoIncrement );
		_aoEntity.push( oEntity );
		_iIdAutoIncrement++;
		onEntityNew.dispatch( oEntity );
		
		// Event funneling
		oEntity.onAbilityAdd.attach( onEntityAbilityAdd );
		oEntity.onAbilityRemove.attach( onEntityAbilityRemove );
		oEntity.onDispose.attach( onEntityDispose );
	}
	public function entity_remove( oEntity :Entity ){
		
		_aoEntity.remove( oEntity );
		
		oEntity.onDispose.dispatch( oEntity );
		
		Disposer.dispose( oEntity );
	}
	
//______________________________________________________________________________
//	Sub-routine

	function _start() {
		onAnyStart.dispatch( this );
	}
	
	function _singleton_add( o :Dynamic ) {
		_mSingleton.set( Type.getClassName( Type.getClass( o ) ), o );
	}

}