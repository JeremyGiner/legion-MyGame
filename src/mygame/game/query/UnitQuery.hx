package mygame.game.query;
import haxe.ds.StringMap;
import legion.IQuery;
import mygame.game.entity.Unit;
import mygame.game.MyGame;
import mygame.game.entity.City;
import mygame.game.tile.Tile;
import space.Vector2i;
import trigger.eventdispatcher.EventDispatcher;
import trigger.ITrigger;
import mygame.game.ability.Position;

/**
 * ...
 * @author GINER Jérémy
 */
class UnitQuery implements IQuery < MyGame, Map<String,Dynamic>, List<Unit> > {
	
	var _oGame :MyGame;
	var _oCache :StringMap<Float>;
	var _iLoop :Int;
	var _oFilter :Map<String,Dynamic>;
	
//_____________________________________________________________________________
//	Constructor
	
	public function new( oGame :MyGame ) {
		
		_iLoop = -1;
		
		_oGame = oGame;
		_oCache = new StringMap<Float>();
		// Assume the city never change tile, or die ... etc
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function data_get( aUnit :Map<String,Dynamic> ) :List<Unit> {
		
		_oFilter = aUnit;
		
		var lUnit = new List<Unit>();
		for ( oUnit in _oGame.entity_get_all() ) {
			
			if ( !Std.is( oUnit, Unit ) )
				continue;
			
			if ( !_test( cast oUnit ) )
				continue;
			
			lUnit.add( cast oUnit );
		}
		
		return lUnit;
		/*
		//
		if ( aUnit.length != 2 )
			throw('Invalid parameter');
		
		//
		var oPos0 = aUnit[0].ability_get(Position);
		var oPos1 = aUnit[1].ability_get(Position);
		
		//
		if ( oPos0 == null || oPos1 == null ) 
			throw('Missing position ability');
		
		// Cache
		_cache_update();
		
		var sKey = aUnit[0].identity_get() + ';' + aUnit[1].identity_get();
		if ( _oCache.exists( sKey ) )
			return _oCache.get( sKey );
		
		// Get result
		var fResult = Vector2i.distance( oPos0, oPos1 );
		_oCache.set( sKey, fResult );
		
		return fResult;
		*/
	}
	
//_____________________________________________________________________________
//	Sub-routine
	
	function _cache_update() {
		
		// Case : Cache is up to date 
		if ( _iLoop == _oGame.loopId_get() ) 
			return;
		
		// Create new cache
		_iLoop == _oGame.loopId_get();
		_oCache = new StringMap<Float>();
	}
	
	/**
	 * 
	 * @param	oUnit
	 * @return	true f ok to ass to list, false otherwise
	 */
	function _test( oUnit :Unit ) {
		
		if( _oFilter.exists( 'type' ) ) {
			var _oType = _oFilter['type'];
			if ( !Std.is( oUnit, _oType) )
				return false;
		}
		
		if( _oFilter.exists( 'ability' ) ) {
			var _oType = _oFilter['ability'];
			if ( oUnit.ability_get(_oType) == null )
				return false;
		}
		
		if( _oFilter.exists( 'owner' ) ) {
			var _oPlayer = _oFilter['owner'];
			if ( oUnit.owner_get() != _oPlayer )
				return false;
		}
		
		return true;
	}
}