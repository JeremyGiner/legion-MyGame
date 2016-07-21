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
import utils.IntTool;
import utils.MapTool;

/**
 * 
 * @author GINER Jérémy
 */
class EntityDistanceTile implements IQuery < MyGame, Array<Entity>, CascadingDistTile > {
	
	var _oGame :MyGame;
	var _mCacheDist :StringMap<CascadingDistTile>;	// Map of distance between entity indexed by a key generated from them
	
	//__________
	// Cache
	/**
	 * Associated keys indexed by entityID
	 */
	var _mEntityKey :IntMap<List<String>>;
	
	var _mKeyToArray :StringMap<Array<Entity>>;
	
//_____________________________________________________________________________
//	Constructor
	
	public function new( oGame :MyGame ) {
		_mEntityKey = new IntMap<List<String>>();
		_mKeyToArray = new StringMap<Array<Entity>>();
		
		_oGame = oGame;
		_mCacheDist = null;
		
		_mCacheDist = new StringMap<CascadingDistTile>();
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function data_get( aUnit :Array<Entity> ) :CascadingDistTile {
		
		// Check parameter
		if ( aUnit.length != 2 ) 
			throw('Invalid parameter : length != 2');
		
		return _cacheValue_get( aUnit[0], aUnit[1] );
	}
	
//_____________________________________________________________________________
//	Sub-routine
	
	function _key_to_array( sKey :String ) {
		return _mKeyToArray.get( sKey );
	}
	
	function _clean_up() {
		// Dispose cascadingvalue taht nobody lsiten
		// And store others
		for ( s in _mCacheDist.keys() ) {
			var o = _mCacheDist.get(s);
			if ( o.onUpdate.triggerListLenght_get() != 0 )
				continue;
			
			o.dispose();
			_mCacheDist.remove( s );
		}
	}
	
	function _cacheValue_get( oEntity0 :Entity, oEntity1 :Entity ) {
		
		// Get key
		var sKey = _key_get( oEntity0, oEntity1 );
		
		// Get CascadingValue
		var oCasca = null;
		if ( !_mCacheDist.exists( sKey ) ) {
			oCasca = new CascadingDistTile( oEntity0, oEntity1 );
			_mCacheDist.set( sKey, oCasca );
		} else {
			oCasca = _mCacheDist.get( sKey );
		}
		
		// Get value
		return oCasca;
	}
	
	function _value_get( oEntity0 :Entity, oEntity1 :Entity ) :Int {
		
		var oPos0 :Position = cast oEntity0.abilityMap_get().get('mygame.game.ability.Position');
		var oPos1 :Position = cast oEntity1.abilityMap_get().get('mygame.game.ability.Position');
		var dx = IntTool.abs( oPos0.tile_get().x_get() - oPos1.tile_get().x_get() );
		var dy = IntTool.abs( oPos0.tile_get().y_get() - oPos1.tile_get().y_get() );
		
		return IntTool.max( dx, dy );
	}
	
	
	/**
	 * 
	 * @param	oEntity0
	 * @param	oEntity1
	 * @return	cache key (ex : "10:51" )
	 */
	function _key_get( oEntity0 :Entity, oEntity1 :Entity ) {
		var sKey = ( oEntity0.identity_get() > oEntity1.identity_get() )?
			oEntity1.identity_get() + ':' + oEntity0.identity_get():
			oEntity0.identity_get() + ':' + oEntity1.identity_get();
		
		_mKeyToArray.set( sKey, [ oEntity0, oEntity1 ] );
		
		return sKey;
	}
}