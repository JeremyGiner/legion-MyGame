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

/**
 * ...
 * @author GINER Jérémy
 */
class UnitDist implements IQuery < MyGame, Array<Unit>, Float > implements ITrigger {
	
	var _oGame :MyGame;
	var _mCacheEntity :IntMap<Entity>;	// Map of entity with Position ability
	var _mCacheDist :StringMap<Float>;	// Map of distance between entity indexed by a key generated from them
	
//_____________________________________________________________________________
//	Constructor
	
	public function new( oGame :MyGame ) {
		
		_oGame = oGame;
		_mCacheEntity = null;
		_mCacheDist = null;
		
		// trigger
		_oGame.onEntityNew.attach( this );
		_oGame.onPositionAnyUpdate.attach( this );
		_oGame.onEntityDispose.attach( this );
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function data_get( aUnit :Array<Unit> ) :Float {
		
		// Check parameter
		if ( aUnit.length != 2 ) 
			throw('Invalid parameter : length != 2');
		
		// Check cache need update
		if ( _mCacheEntity == null )
			_cache_update();
		
		return _mCacheDist.get( _key_get( aUnit[0], aUnit[1] ) );
	}
	
	public function entityList_get_byProximity( oEntity0 :Entity, fRadius :Float ) {
		var l = new List<Entity>();
		
		// TODO use a sorted array
		for ( oEntity1 in _mCacheEntity ) {
			if ( _mCacheDist.get( _key_get( oEntity0, oEntity1 ) ) <= fRadius ) {
				l.push( oEntity1 );
			}
		}
		
		return l;
	}
	
//_____________________________________________________________________________
//	Sub-routine
	
	function _cache_update() {
		
		_mCacheEntity = new IntMap<Entity>();
		_mCacheDist = new StringMap<Float>();
		
		// Create new cache
		for ( oEntity in _oGame.entity_get_all() ) {
			
			if ( !_test( cast oEntity ) )
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
		if ( oEntity.ability_get(Position) == null )
			return false;
		
		return true;
	}
	
	function _cacheValue_create( oEntity0 :Entity ) {
		
		// Save distance form other
		_cacheValue_update( oEntity0 );
		
		// Save himself
		_mCacheEntity.set( oEntity0.identity_get(), oEntity0 );
		_mCacheDist.set( 
			_key_get( oEntity0, oEntity0 ), 
			0	// Assume it's always 0
		);
		
		// Trigger setup
		oEntity0.ability_get(Position).onUpdate.attach( this );
	}
	
	function _cacheValue_remove( oEntity0 :Entity ) {
		// Remove distance form other
		for (  oEntity1 in _mCacheEntity ) {
			_mCacheDist.remove(
				_key_get( oEntity0, oEntity1 )
			);
		}
		
		// Remove himself
		_mCacheEntity.remove( oEntity0.identity_get() );
		
		// Trigger remove
		oEntity0.ability_get(Position).onUpdate.remove( this );
	}
	
	function _cacheValue_update( oEntity0 :Entity ) {
		// Save distance form other
		for (  oEntity1 in _mCacheEntity ) {
			_mCacheDist.set( 
				_key_get( oEntity0, oEntity1 ), 
				oEntity0.ability_get(Position).distance_get(  
					oEntity1.ability_get(Position)
				) 
			);
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
			return _key_get(oEntity1, oEntity0);
		
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
			var oEntity :Entity = cast oSource.event_get();
			if ( _test( oEntity ) )
				_cacheValue_create( oEntity );
			return;
		}
		
		// Dispose
		if ( oSource == _oGame.onEntityDispose  ) { 
			var oEntity :Entity = cast oSource.event_get();
			_cacheValue_remove( oEntity );
			return;
		}
		
		// Position update
		if ( oSource == _oGame.onPositionAnyUpdate ) {
			_cacheValue_update( _oGame.onPositionAnyUpdate.event_get().unit_get() );
			return;
		}
		
	}
}
