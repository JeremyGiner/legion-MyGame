package mygame.game.query;
import haxe.ds.StringMap;
import legion.IQuery;
import mygame.game.MyGame;
import mygame.game.entity.City;
import mygame.game.tile.Tile;
import trigger.eventdispatcher.EventDispatcher;
import trigger.ITrigger;
import mygame.game.ability.Position;

/**
 * ...
 * @author GINER Jérémy
 */
class CityTile implements IQuery < MyGame, Tile, List<City> > {
	
	var _oGame :MyGame;
	var _oCache :StringMap<List<City>>;
	
	public function new( oGame :MyGame ) {
		
		_oGame = oGame;
		_oCache = new StringMap<List<City>>();
		// Assume the city never change tile, or die ... etc
		
		
	}
	
	
	public function data_get( oTile :Tile ) :List<City> {
		var s = oTile.x_get() + ';' + oTile.y_get();
		
		if ( _oCache.exists( s ) )
			return _oCache.get( s );
		
		_oCache.set( s, new List<City>() );
		
		for ( oUnit in _oGame.entity_get_all() ) {
			if ( 
				Std.is(oUnit, City) &&
				oUnit.ability_get(Position).tile_get() == oTile
			) {
				_oCache.get( s ).add( cast oTile );
			}
		}
		
		return _oCache.get( s );
	}
}