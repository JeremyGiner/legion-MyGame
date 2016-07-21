package legion;

import haxe.ds.IntMap;
import haxe.ds.StringMap;
import legion.ability.IAbility;
import legion.entity.Entity;
import legion.entity.Player;
import trigger.eventdispatcher.EventDispatcherFunel;
import trigger.EventDispatcher2;
import utils.Disposer;

/**
 * ...
 * @author GINER Jérémy
 */
class Game {
	
	var _iLoop :Int = 0;
	
	var _mEntity :IntMap<Entity>;
	var _iIdAutoIncrement :Int = 0;
	var _mSingleton :StringMap<Dynamic>;
	
	var _aProcessCallOrder :Array<IProcess>;
	
	public var onEntityNew :EventDispatcher2<Entity>;
	public var onEntityDispose :EventDispatcherFunel<Entity>;
	
	public var onEntityAbilityAdd :EventDispatcherFunel<EventEntityAbility>;
	public var onEntityAbilityRemove :EventDispatcherFunel<EventEntityAbility>;
	
//______________________________________________________________________________
//	Constructor

    function new() {
        _mEntity = new IntMap<Entity>();
		_mSingleton = new StringMap<Dynamic>();
		
		_aProcessCallOrder = new Array<IProcess>();
        
        onEntityNew = new EventDispatcher2<Entity>();
        onEntityDispose = new EventDispatcherFunel<Entity>();
        onEntityAbilityAdd = new EventDispatcherFunel<EventEntityAbility>();
        onEntityAbilityRemove = new EventDispatcherFunel<EventEntityAbility>();
    }
	
//______________________________________________________________________________
//	Accessor
	
	public function loopId_get(){ return _iLoop; }

	public function entity_get( i :Int) {
		return _mEntity.get( i );
	}
	
	public function entity_get_all() { return _mEntity; }
	
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
		_mEntity.set( _iIdAutoIncrement, oEntity );
		_iIdAutoIncrement++;
		onEntityNew.dispatch( oEntity );
		
		// Event funneling
		oEntity.onAbilityAdd.attach( onEntityAbilityAdd );
		oEntity.onAbilityRemove.attach( onEntityAbilityRemove );
		oEntity.onDispose.attach( onEntityDispose );
	}
	public function entity_remove( oEntity :Entity ){
		
		_mEntity.remove( oEntity.identity_get() );
		
		oEntity.onDispose.dispatch( oEntity );
		
		Disposer.dispose( oEntity );
	}
	
//______________________________________________________________________________
//	Process
	
	public function process() {
		_iLoop++;
		
		for ( oProcess in _aProcessCallOrder )
			oProcess.process();
	}

//______________________________________________________________________________
//	Sub-routine
	
	function _singleton_add( o :Dynamic ) {
		_mSingleton.set( Type.getClassName( Type.getClass( o ) ), o );
	}

}