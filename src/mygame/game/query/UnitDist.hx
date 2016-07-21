package mygame.game.query;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
import legion.entity.Entity;
import legion.IQuery;
import mygame.game.entity.Unit;
import mygame.game.MyGame;
import mygame.game.entity.City;
import mygame.game.tile.Tile;
import space.Vector2i;
import trigger.eventdispatcher.EventDispatcher;
import trigger.ITrigger;
import mygame.game.ability.Position;
import trigger.*;
import utils.MapTool;

/**
 * ...
 * @author GINER Jérémy
 */
class EntityDistance implements IQuery < MyGame, Array<Entity>, Float > implements ITrigger {
	
	var _oGame :MyGame;
	var _mCacheEntity :IntMap<Entity>;	// Map of entity with Position ability
	var _mCacheDist :StringMap<Float>;	// Map of distance between entity indexed by a key generated from them
	
	/**
	 * A list of entity in wait to be processed
	 */
	var _mEntityQueue :Map<Int,Entity>;
	
	public var onUpdate :EventDispatcher2<Entity>;
	
//_____________________________________________________________________________
//	Constructor
	
	public function new( oGame :MyGame ) {
		_mEntityQueue = new Map<Int,Entity>();
		
		_oGame = oGame;
		_mCacheEntity = null;
		_mCacheDist = null;
		
		onUpdate = new EventDispatcher2<Entity>();
		
		// trigger
		_oGame.onEntityNew.attach( this );
		_oGame.onPositionAnyUpdate.attach( this );
		_oGame.onEntityDispose.attach( this );
		
		_oGame.onEntityAbilityRemove.attach( this );
		_oGame.onEntityAbilityAdd.attach( this );
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function data_get( aUnit :Array<Entity> ) :Float {
		
		// Check parameter
		if ( aUnit.length != 2 ) 
			throw('Invalid parameter : length != 2');
		
		// Check cache need update
		if ( _mCacheEntity == null )
			_cache_update();
		
		// Queue process
		_queue_process();
		
		// Get value
		var fDistSqed = _cacheValue_get( aUnit[0], aUnit[1] ); 
		
		return ( fDistSqed == null ) ? null : Math.sqrt( fDistSqed );
	}
	
	public function distanceSqed_get( oEntity0 :Entity, oEntity1 :Entity ) :Float {
		
		// Check cache need update
		if ( _mCacheEntity == null )
			_cache_update();
		
		_queue_process();
		
		return _cacheValue_get( oEntity0, oEntity1 );
	}
	
	public function entityList_get_byProximity( oEntity0 :Entity, fRadius :Float ) {
		var l = new List<Entity>();
		
		// Check cache need update
		if ( _mCacheEntity == null )
			_cache_update();
		
		_queue_process();
		
		// TODO use a sorted array
		var fRadiusSqed = fRadius*fRadius;
		for ( oEntity1 in _mCacheEntity ) {
			var d = _cacheValue_get( oEntity0, oEntity1 );
			
			if ( d <= fRadiusSqed ) {
				l.push( oEntity1 );
			}
		}
		
		return l;
	}
	public function queue_process() {
		_queue_process();
	}
//_____________________________________________________________________________
//	Sub-routine
	
	function _queue_process() {
		return;
		// Process Queue
		var lEntityQueue :List<Entity> = MapTool.toList( _mEntityQueue );
		if ( lEntityQueue.length == 0 )
			return;
		
		var lEntityAll :List<Entity> = MapTool.toList( _mCacheEntity );
		
		var lEntity = lEntityAll;
		var lEntityNext = new List<Entity>();
		var lEntityUpdated = new List<Array<Entity>>();
		for ( oEntity0 in lEntityQueue ) {
			// Assume only entity with position will use the queue
			/*
			if ( _test(oEntity) )
				_mCache.set( oEntity.identity_get(), oEntity );
			else
				_mCache.remove( oEntity.identity_get() );
			*/
			//_cacheValue_update( oEntity );
			
			
			// Save distance form other
			lEntityNext = new List<Entity>();
			for ( oEntity1 in lEntity ) {
				_mCacheDist.set( 
					_key_get( oEntity0, oEntity1 ), 
					-1
				);
				
				lEntityUpdated.push( [ oEntity0, oEntity1 ] );
				
				// Remove Entity0 for next loop
				if ( oEntity1 != oEntity0 )
					lEntityNext.push( oEntity1 );
			}
			lEntity = lEntityNext;
		}
		// Flush queue
		_mEntityQueue = new Map<Int,Entity>();
		
		
		for (  aEntity in lEntityUpdated ) {
			onUpdate.dispatch( aEntity );
		}
	}
	
	function _cacheValue_get( oEntity0 :Entity, oEntity1 :Entity ) {
		var sKey = _key_get( oEntity0, oEntity1 );
		
		// Get value
		var fDistSqed = _mCacheDist.get( sKey ); 
		
		// Case value require update
		if ( fDistSqed == -1 ) {
			fDistSqed = untyped oEntity0.abilityMap_get().get('mygame.game.ability.Position').distanceSqed_get(  
				oEntity1.abilityMap_get().get('mygame.game.ability.Position')
			);
			_mCacheDist.set( sKey, fDistSqed );
		}
		
		return fDistSqed;
	}
	
	function _cache_update() {
		
		_mCacheEntity = new IntMap<Entity>();
		_mCacheDist = new StringMap<Float>();
		
		// Create new cache
		for ( oEntity in _oGame.entity_get_all() ) {
			
			if ( !_test( oEntity ) )
				continue;
			
			_cacheValue_create( oEntity );
		}
	}
	
	/**
	 * 
	 * @param	oUnit
	 * @return	true if ok to add to list, false otherwise
	 */
	function _test( oEntity :Entity ) {
		if ( oEntity.abilityMap_get().get('mygame.game.ability.Position') == null )
			return false;
		
		return true;
	}
	
	function _cacheValue_create( oEntity0 :Entity ) {
		// Save himself
		_mCacheEntity.set( oEntity0.identity_get(), oEntity0 );
		
		// Save distance form other
		_cacheValue_update( oEntity0 );
	}
	
	function _cacheValue_remove( oEntity0 :Entity ) {
		// Remove himself
		_mCacheEntity.remove( oEntity0.identity_get() );
		
		
		// Remove distance form other
		for (  oEntity1 in _mCacheEntity ) {
			_mCacheDist.remove(
				_key_get( oEntity0, oEntity1 )
			);
		}
	}
	
	function _cacheValue_update( oEntity0 :Entity ) {
		// Save distance form other
		for (  oEntity1 in _mCacheEntity ) {
			_mCacheDist.set( 
				_key_get( oEntity0, oEntity1 ), 
				-1
			);
			onUpdate.dispatch( [oEntity0, oEntity1] );
		}
	}
	
	/**
	 * 
	 * @param	oEntity0
	 * @param	oEntity1
	 * @return	cache key (ex : "10:51" )
	 */
	function _key_get( oEntity0 :Entity, oEntity1 :Entity ) {
		if ( oEntity0.identity_get() > oEntity1.identity_get() )
			return oEntity1.identity_get() + ':' + oEntity0.identity_get();
		
		return oEntity0.identity_get() + ':' + oEntity1.identity_get();
	}
	
	
//_____________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) {
		
		// Case : no cache to update
		if ( _mCacheEntity == null )
			return;
		
		// New
		if ( oSource == _oGame.onEntityNew  ) {
			var oEntity :Entity = _oGame.onEntityNew.event_get();
			if ( _test( oEntity ) )
				_cacheValue_create( oEntity );
			return;
		}
		
		// Dispose
		if ( oSource == _oGame.onEntityDispose  ) { 
			_cacheValue_remove( _oGame.onEntityDispose.event_get() );
			return;
		}
		
		// Position add
		if ( oSource == _oGame.onEntityAbilityAdd ) {
			var oEntity = _oGame.onEntityAbilityAdd.event_get().entity;
			
			if( _mCacheEntity.exists( oEntity.identity_get() ) )
				return;
			
			if ( _test(oEntity) )
				_cacheValue_create( oEntity );
			return;
		}
		
		// Position remove
		if ( oSource == _oGame.onEntityAbilityRemove ) {
			var oEntity = _oGame.onEntityAbilityRemove.event_get().entity;
			if ( !_test(oEntity) )
				_cacheValue_remove( oEntity );
			return;
		}
		
		// Position update
		if ( oSource == _oGame.onPositionAnyUpdate ) {
			//_cacheValue_update( _oGame.onPositionAnyUpdate.event_get().unit_get() );
			var oEntity = _oGame.onPositionAnyUpdate.event_get().unit_get();
			_mEntityQueue.set( oEntity.identity_get(), oEntity );
			return;
		}
		
	}
}