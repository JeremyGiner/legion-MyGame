package mygame.game.utils;
import haxe.ds.StringMap;
import mygame.game.entity.WorldMap;
import mygame.game.tile.Tile;

/**
 * ...
 * @author GINER Jérémy
 */
class CachePathfinder {

	var _mCache :StringMap<PathFinderFlowField>;
	
	public function new() {
		_mCache = new StringMap<PathFinderFlowField>();
	}
	
	
	public function get(
		oWorldMap :WorldMap,
		lPosition :List<Tile>,
		lDestination :List<Tile>, 
		pTest :IValidatorTile
	) {
		var sKey = _key_get(
			oWorldMap,
			lDestination,
			pTest
		);
		
		if ( !_mCache.exists( sKey ) )
			_mCache.set( sKey, new PathFinderFlowField(oWorldMap, lPosition, lDestination, pTest) );
		
		return _mCache.get( sKey );
	}
	
	function _key_get( 
		oWorldMap :WorldMap,
		lDestination :List<Tile>, 
		pTest :IValidatorTile
	) {
		var s = oWorldMap.identity_get() + ':' +Type.getClassName( Type.getClass(pTest) )+':';
		for( oTile in lDestination )
			s += oTile.x_get()+';'+oTile.y_get()+':';
		return s;
	}
	
}