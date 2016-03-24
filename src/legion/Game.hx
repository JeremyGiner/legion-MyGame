package legion;

import haxe.ds.StringMap;
import legion.ability.IAbility;
import legion.entity.Entity;
import legion.entity.Player;
import trigger.eventdispatcher.EventDispatcher;
import trigger.EventDispatcher2;

class Game {
	
	var _aoEntity :Array<Entity>;
	var _iIdAutoIncrement :Int = 0;
	var _mSingleton :StringMap<Dynamic>;
	
	public var onEntityNew :EventDispatcher2<Entity>;
	public var onEntityUpdate :EventDispatcher2<Entity>;
	public var onEntityDispose :EventDispatcher2<Entity>;
	
	public var onAbilityDispose :EventDispatcher2<IAbility>;
	
	public static var onAnyStart :EventDispatcher = {new EventDispatcher();};
	
//______________________________________________________________________________
//	Constructor

    function new() {
        _aoEntity = new Array<Entity>();
		_mSingleton = new StringMap<Dynamic>();
        
        onEntityNew = new EventDispatcher2<Entity>();
        onEntityUpdate = new EventDispatcher2<Entity>();
        onEntityDispose = new EventDispatcher2<Entity>();
		
		onAbilityDispose = new EventDispatcher2<IAbility>();
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
	}
	public function entity_remove( oEntity :Entity ){
		_aoEntity.remove( oEntity );
		onEntityDispose.dispatch( oEntity );
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