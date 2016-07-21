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
import utils.CascadingValue;
import utils.MapTool;

/**
 * pos update ->
 * 	cascading dist update ->
 * 		cascading range validator -> 
 * 			cascading composed validator ->
 * 				cascading target list
 * @author GINER Jérémy
 */
class EntityDistance implements IQuery < MyGame, Array<Entity>, CascadingDistSqred > {
	
	var _oGame :MyGame;
	var _mCacheDist :StringMap<CascadingDistSqred>;	// Map of distance between entity indexed by a key generated from them
	
	/**
	 * A list of entity in wait to be processed
	 */
	var _mEntityQueue :Map<Int,Entity>;
	
	/**
	 * used to get by proximity
	 */
	var _oQueryEntityPosition :EntityQuery;
	
	//__________
	// Cache
	
	var _mKeyToArray :StringMap<Array<Entity>>;
	
	// EvDisp
	public var onUpdate :EventDispatcher2<Entity>;
	
//_____________________________________________________________________________
//	Constructor
	
	public function new( oGame :MyGame ) {
		onUpdate = new EventDispatcher2<Entity>();
		_mKeyToArray = new StringMap<Array<Entity>>();
		_mEntityQueue = new Map<Int,Entity>();
		
		_oGame = oGame;
		
		_oQueryEntityPosition = new EntityQuery( _oGame, new ValidatorEntity( ['ability' => Position] ) );
		
		_mCacheDist = new StringMap<CascadingDistSqred>();
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function data_get( aUnit :Array<Entity> ) :CascadingDistSqred {
		
		// Check parameter
		if ( aUnit.length != 2 ) 
			throw('Invalid parameter : length != 2');
		
		// Get value
		return _cacheValue_get( aUnit[0], aUnit[1] ); 
	}
	
	public function distanceSqed_get( oEntity0 :Entity, oEntity1 :Entity ) :CascadingDistSqred {
		
		return _cacheValue_get( oEntity0, oEntity1 );
	}
	/**
	 * Should be deprecated
	 * @param	oEntity0
	 * @param	fRadius
	 */
	public function entityList_get_byProximity( oEntity0 :Entity, fRadius :Float ) {
		
		// TODO use a sorted array
		var l = new List<Entity>();
		var fRadiusSqed = fRadius*fRadius;
		for ( oEntity1 in _oQueryEntityPosition.data_get(null) ) {
			var d = _cacheValue_get( oEntity0, oEntity1 ).get();
			
			if ( d <= fRadiusSqed ) {
				l.push( oEntity1 );
			}
		}
		
		return l;
	}
	
	/**
	 * TODO : remove
	 */
	public function queue_process() {
		//_queue_process();
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
			oCasca = new CascadingDistSqred( oEntity0, oEntity1 );
			_mCacheDist.set( sKey, oCasca );
		} else {
			oCasca = _mCacheDist.get( sKey );
		}
		
		// Get value
		return oCasca;
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