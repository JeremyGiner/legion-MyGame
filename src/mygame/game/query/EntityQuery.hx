package mygame.game.query;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
import legion.entity.Entity;
import legion.IQuery;
import mygame.game.ability.Loyalty;
import mygame.game.ability.UnitAbility;
import mygame.game.entity.Unit;
import mygame.game.MyGame;
import mygame.game.entity.City;
import mygame.game.tile.Tile;
import mygame.game.utils.IValidatorEntity;
import space.Vector2i;
import trigger.*;
import mygame.game.ability.Position;
import utils.ListTool;
import utils.MapTool;

/**
 * ...
 * @author GINER Jérémy
 */
class EntityQuery implements IQuery < MyGame, Bool, IntMap<Entity> > implements ITrigger {
	
	var _oGame :MyGame;
	
	var _mCache :IntMap<Entity>;
	
	var _aValidator :Array<IValidatorEntity>;
	var _oValidator :IValidatorEntity;
	
	var _aEventDispatcher :Array<IEventDispatcher>;
	
	/**
	 * A list of entity in wait to be processed
	 */
	var _mEntityQueue :Map<Int,Entity>;
	
//_____________________________________________________________________________
//	Constructor
	
	public function new( 
		oGame :MyGame, 
		oFilter :IValidatorEntity, 
		aEventDispatcher :Array<IEventDispatcher> = null 
	) {
		_mEntityQueue = new Map<Int,Entity>();
		
		_aEventDispatcher = aEventDispatcher!=null ? aEventDispatcher : [];
		_oGame = oGame;
		
		_mCache = null;
		
		// TODO : validate filter
		_oValidator = oFilter;
		
		// trigger
		_oGame.onEntityNew.attach( this );
		
		// concern only ability filter
		_oGame.onEntityAbilityAdd.attach( this );
		_oGame.onEntityAbilityRemove.attach( this );
		
		// concern only player filter
		_oGame.onLoyaltyAnyUpdate.attach( this );
		//_oGame.onPositionAnyUpdate.attach( this );
		
		_oGame.onEntityDispose.attach( this );
		
		for ( oEventDispatcher in _aEventDispatcher ) {
			oEventDispatcher.attach( this );
		}
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function data_get( o :Bool ) :IntMap<Entity> {
		
		if ( _mCache == null )
			_cache_update();
		
		// Process Queue
		var lEntityQueue :List<Entity> = MapTool.toList( _mEntityQueue );
		if ( lEntityQueue.length != 0 )
			_queue_process( lEntityQueue );
		
		// Flush queue
		_mEntityQueue = new Map<Int,Entity>();
		
		return _mCache;
	}
	
//_____________________________________________________________________________
//	Sub-routine
	
	function _queue_process( lEntityQueue :List<Entity> ) {
		for ( oEntity in lEntityQueue ) {
			if ( _test(oEntity) )
				_mCache.set( oEntity.identity_get(), oEntity );
			else
				_mCache.remove( oEntity.identity_get() );
		}
	}
	function _cache_update() {
		
		_mCache = new IntMap<Entity>();
		
		// Create new cache
		for ( oEntity in _oGame.entity_get_all() ) {
			
			if ( !_test( cast oEntity ) )
				continue;
			
			_mCache.set( oEntity.identity_get(), oEntity );
		}
	}
	
	/**
	 * 
	 * @param	oUnit
	 * @return	true if ok to add to list, false otherwise
	 */
	function _test( oEntity :Entity ) {
		return _oValidator.validate( oEntity );
	}
	
//_____________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) {
		
		// Case : no cache to update
		if ( _mCache == null )
			return;
		
		var oEntity :Entity = cast oSource.event_get();
		
		if ( oSource == _oGame.onEntityAbilityAdd ) {
			var oEntity = _oGame.onEntityAbilityAdd.event_get().entity;
			if ( _test(oEntity) )
				_mCache.set( oEntity.identity_get(), oEntity );
			return;
		}
		
		if ( oSource == _oGame.onEntityAbilityRemove ) {
			var oEntity = _oGame.onEntityAbilityRemove.event_get().entity;
			if ( !_test(oEntity) )
				_mCache.remove( oEntity.identity_get() );
			return;
		}
		
		
		if ( oSource == _oGame.onLoyaltyAnyUpdate ) {
			var oEntity = _oGame.onLoyaltyAnyUpdate.event_get().entity_get();
			if ( _test(oEntity) )
				_mCache.set( oEntity.identity_get(), oEntity );
			else
				_mCache.remove( oEntity.identity_get() );
			return;
		}
		/*
		if ( oSource == _oGame.onPositionAnyUpdate ) {
			var oEntity = _oGame.onPositionAnyUpdate.event_get().unit_get();
			if ( _test(oEntity) )
				_mCache.set( oEntity.identity_get(), oEntity );
			else
				_mCache.remove( oEntity.identity_get() );
			return;
		}*/
		
		//_______________
		
		if ( oSource == _oGame.onEntityNew ) {
			if ( _test( oEntity ) )
				_mCache.set( oEntity.identity_get(), oEntity );
			return;
		}
		
		if ( oSource == _oGame.onEntityDispose  ) {
			_mCache.remove( oEntity.identity_get() );
			return;
		}
		
		//_______________
		if ( Std.is( oSource.event_get(), Entity ) ) {
			var oEntity :Entity = cast oSource.event_get();
			_mEntityQueue.set( oEntity.identity_get(), oEntity );
			return;
		}
		
		if ( Std.is( oSource.event_get(), UnitAbility ) ) {
			var oEntity :Entity = cast oSource.event_get().unit_get();
			_mEntityQueue.set( oEntity.identity_get(), oEntity );
			return;
		}
		throw('invalid event type : must be Entity or UnitAbility');
	}
	
//_____________________________________________________________________________
//	Disposer

	public function dispose() {
				// trigger
		_oGame.onEntityNew.remove( this );
		
		// concern only ability filter
		_oGame.onEntityAbilityAdd.remove( this );
		_oGame.onEntityAbilityRemove.remove( this );
		
		// concern only player filter
		_oGame.onLoyaltyAnyUpdate.remove( this );
		_oGame.onPositionAnyUpdate.remove( this );
		
		_oGame.onEntityDispose.remove( this );
		
		for ( oEventDispatcher in _aEventDispatcher ) {
			oEventDispatcher.remove( this );
		}
	}
}