package legion.entity;

import haxe.ds.StringMap;
import legion.ability.IAbility;
import utils.Disposer;
import utils.IDisposable;

import trigger.eventdispatcher.EventDispatcher;
import trigger.eventdispatcher.EventDispatcher;

/**
 * Component of Game, like pawn on a board game.
 * 
 * @author GINER Jérémy
 */
class Entity implements IDisposable {
	
	var _iIdentity :Int;
	var _oGame :Game;
	var _moAbility :StringMap<IAbility>;
	
	public var onUpdate :EventDispatcher;
	public var onDispose :EventDispatcher;
	
//______________________________________________________________________________
//	Constructor

	public function new( oGame :Game ){
		_iIdentity = null;
		_oGame = oGame;
		
		_moAbility = new StringMap<IAbility>();
		
		onUpdate = new EventDispatcher();
		onDispose = new EventDispatcher();
	}
	
//______________________________________________________________________________
//	Accessor

	public function dispose_check() { return _oGame == null; }
	public function identity_get() { return _iIdentity; }
	public function identity_set( i :Int ) { _iIdentity = i; }
	public function key_get() { return _iIdentity; }
	public function game_get() { return _oGame; }
	
	public static function get_byKey( oGame :Game, iKey :Int ) {
		for( oEntity in oGame.entity_get_all() ) {
			if( oEntity.key_get() == iKey )
				return oEntity;
		}
		return null;
	}
	
	public function ability_remove<CAbility:IAbility>( oClass :Class<CAbility> ) {
		_moAbility.remove( Type.getClassName( oClass ) );
	}
	function _ability_add( oAbility :IAbility) {
		_moAbility.set( Type.getClassName( Type.getClass( oAbility ) ), oAbility );
	}
	
	public function ability_get<CAbility:IAbility>( oClass :Class<CAbility> ) :CAbility {
		// Check if oClass derived from IEntityAbility
		return cast _moAbility.get( Type.getClassName( oClass ) );
	}
	
	public function abilityMap_get() {
		return _moAbility;
	}
	
//______________________________________________________________________________
//	Disposer

	public function dispose() {
		// Dispatch
		onDispose.dispatch( this );
		
		// Dispose of all necessary members
		for( oAbility in _moAbility )
			oAbility.dispose();
		
		if( _oGame != null ) {
			_oGame.entity_remove( this );
			_oGame = null;
		}
			
		// Wipe all
		Disposer.dispose( this );
	}

}