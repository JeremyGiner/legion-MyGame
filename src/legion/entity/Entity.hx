package legion.entity;

import haxe.ds.StringMap;
import legion.ability.IAbility;
import legion.IProcessBehaviour;
import trigger.EventDispatcher2;
import utils.Disposer;
import utils.IDisposable;

/**
 * Component of Game, like pawn on a board game.
 * 
 * @author GINER Jérémy
 */
class Entity /*implements IDisposable*/ {
	
	var _iIdentity :Int;
	var _oGame :Game;
	var _moAbility :StringMap<IAbility>;
	
	var _lBehavour :List<IProcessBehaviour<Dynamic>>;
	
	//public var onUpdate :EventDispatcher;
	public var onAbilityAdd :EventDispatcher2<EventEntityAbility>;
	public var onAbilityRemove :EventDispatcher2<EventEntityAbility>;
	public var onDispose :EventDispatcher2<Entity>;
	
//______________________________________________________________________________
//	Constructor

	public function new( oGame :Game ) {
		
		_moAbility = new StringMap<IAbility>();
		_lBehavour = new List<IProcessBehaviour<Dynamic>>();
		
		_iIdentity = null;
		_oGame = oGame;
		
		
		//onUpdate = new EventDispatcher();
		onAbilityAdd = new EventDispatcher2<EventEntityAbility>();
		onAbilityRemove = new EventDispatcher2<EventEntityAbility>();
		onDispose = new EventDispatcher2<Entity>();
	}
	
//______________________________________________________________________________
//	Accessor

	public function dispose_check() { return _oGame == null; }
	public function identity_get() { return _iIdentity; }
	public function identity_set( i :Int ) { _iIdentity = i; }
	public function game_get() { return _oGame; }
	
	public function ability_get<CAbility:IAbility>( oClass :Class<CAbility> ) :CAbility {
		// Check if oClass derived from IEntityAbility
		if ( _moAbility == null )
			throw('sdqsdqs');
		return cast _moAbility.get( Type.getClassName( oClass ) );
	}
	
	public function abilityMap_get() {
		return _moAbility;
	}
	
	public function behaviourList_get() {
		return _lBehavour;
	}
	
//______________________________________________________________________________
//	Modifier
	
	/**
	 * SHOULD ONLY BE USED BY PROCESSBEHAVIOUR
	 * @param	oBeha
	 */
	public function behaviour_add( oBeha :IProcessBehaviour<Dynamic> ) {
		_lBehavour.push( oBeha );
	}

	public function ability_add( oAbility :IAbility ) {
		_ability_add( oAbility );
		onAbilityAdd.dispatch( { ability: oAbility, entity: this } );
	}
	
	public function ability_remove<CAbility:IAbility>( oClass :Class<CAbility> ) {
		
		var sClassName = Type.getClassName( oClass );
		
		if ( !_moAbility.exists( sClassName ) )
			return;
		
		var oAbility = _moAbility.get(sClassName);
		_moAbility.remove( sClassName );
		
		onAbilityRemove.dispatch( { ability: oAbility, entity: this } );
	}

//______________________________________________________________________________
//	Sub-routine
	
	function _ability_add( oAbility :IAbility ) {
		_moAbility.set( Type.getClassName( Type.getClass( oAbility ) ), oAbility );
	}

}

typedef EventEntityAbility = {
	var ability :IAbility;
	var entity :Entity;
}
