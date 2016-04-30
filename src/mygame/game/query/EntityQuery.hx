package mygame.game.query;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
import legion.entity.Entity;
import legion.IQuery;
import mygame.game.ability.Loyalty;
import mygame.game.entity.Unit;
import mygame.game.MyGame;
import mygame.game.entity.City;
import mygame.game.tile.Tile;
import space.Vector2i;
import trigger.*;
import mygame.game.ability.Position;

/**
 * ...
 * @author GINER Jérémy
 */
class EntityQuery implements IQuery < MyGame, Bool, IntMap<Entity> > implements ITrigger {
	
	var _oGame :MyGame;
	
	var _oCache :IntMap<Entity>;
	
	var _oFilter :Map<String,Dynamic>;
	
//_____________________________________________________________________________
//	Constructor
	
	public function new( oGame :MyGame, oFilter :Map<String,Dynamic> ) {
		
		_oGame = oGame;
		
		_oCache = null;
		
		// TODO : validate filter
		_oFilter = oFilter;
		
		// trigger
		_oGame.onEntityNew.attach( this );
		
		// concern only ability filter
		_oGame.onEntityAbilityAdd.attach( this );
		_oGame.onEntityAbilityRemove.attach( this );
		
		// concern only player filter
		_oGame.onLoyaltyAnyUpdate.attach( this );
		
		_oGame.onEntityDispose.attach( this );
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function data_get( o :Bool ) :IntMap<Entity> {
		
		if ( _oCache == null )
			_cache_update();
		return _oCache;
	}
	
//_____________________________________________________________________________
//	Sub-routine
	
	function _cache_update() {
		
		_oCache = new IntMap<Entity>();
		
		// Create new cache
		for ( oEntity in _oGame.entity_get_all() ) {
			
			if ( !_test( cast oEntity ) )
				continue;
			
			_oCache.set( oEntity.identity_get(), oEntity );
		}
	}
	
	/**
	 * 
	 * @param	oUnit
	 * @return	true if ok to add to list, false otherwise
	 */
	function _test( oEntity :Entity ) {
		
		for ( sKey in _oFilter.keys() ) {
			switch( sKey ) {
				case 'class' : 
					var _oType = _oFilter['class'];
					if ( !Std.is( oEntity, _oType) )
						return false;
				case 'ability' : 
					var _oType = _oFilter['ability'];
					if ( oEntity.ability_get(_oType) == null )
						return false;
				case 'player' :
					var oLoyalty = oEntity.ability_get(Loyalty);
					
					if ( 
						oLoyalty == null || 
						oLoyalty.owner_get() == null ||
						oLoyalty.owner_get().playerId_get() != _oFilter['player']
					)
						return false;
					
				default:
					throw('unknown filter key "'+sKey+'"');
			}
		}
		
		return true;
	}
	
//_____________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) {
		
		// Case : no cache to update
		if ( _oCache == null )
			return;
		
		var oEntity :Entity = cast oSource.event_get();
		
		if ( oSource == _oGame.onEntityAbilityAdd ) {
			var oEntity = _oGame.onEntityAbilityAdd.event_get().entity;
			if ( _test(oEntity) )
				_oCache.set( oEntity.identity_get(), oEntity );
			return;
		}
		
		if ( oSource == _oGame.onEntityAbilityRemove ) {
			var oEntity = _oGame.onEntityAbilityAdd.event_get().entity;
			if ( !_test(oEntity) )
				_oCache.remove( oEntity.identity_get() );
			return;
		}
		
		
		if ( oSource == _oGame.onLoyaltyAnyUpdate ) {
			var oEntity = _oGame.onLoyaltyAnyUpdate.event_get().unit_get();
			if ( _test(oEntity) )
				_oCache.set( oEntity.identity_get(), oEntity );
			else
				_oCache.remove( oEntity.identity_get() );
			return;
		}
		
		
		if ( oSource == _oGame.onEntityNew ) {
			if ( _test( oEntity ) )
				_oCache.set( oEntity.identity_get(), oEntity );
			return;
		}
		
		if ( oSource == _oGame.onEntityDispose  ) {
			_oCache.remove( oEntity.identity_get() );
			return;
		}
	}
}