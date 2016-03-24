package mygame.game.ability;
import mygame.game.entity.Unit;
import mygame.game.tile.Tile;
import mygame.game.entity.WorldMap;
import mygame.game.query.CityTile;

/**
 * ...
 * @author GINER Jérémy
 */
class PositionPlan extends UnitAbility {

	var _iCodePlan :Int;
	
	public function new( oUnit :Unit, iCodePlan :Int ) {
		super( oUnit );
		
		_iCodePlan = iCodePlan;
	}
	
	/**
	 * 
	 * @param	oTile
	 * @return	Bool true if walkable
	 */
	public function tile_check( oTile :Tile ) :Bool {
		
		switch( _iCodePlan ) {
			case 0 :
				/* Air unit */
				return true;
			case 1 :
				/* Vehicule */
				return PositionPlan.isLandWalkable( oTile );
			case 2 :
				/* infantry */
				return PositionPlan.isFootWalkable( oTile );
		}
		throw('Invalid code plan : '+ _iCodePlan );
		return false;
	}
	
	public static function isLandWalkable( oTile :Tile ):Bool{
		if( oTile == null ) return false;
		if ( oTile.type_get() == WorldMap.TILETYPE_SEA ) return false;
		if( oTile.type_get() == WorldMap.TILETYPE_MOUNTAIN ) return false;
		if ( oTile.map_get().game_get().query_get(CityTile).data_get( oTile ).length != 0 ) return false;
		return true;
	}
	
	public static function isFootWalkable( oTile :Tile ):Bool{
		if( oTile == null ) return false;
		if( oTile.type_get() == WorldMap.TILETYPE_GRASS ) return true;
		if( oTile.type_get() == WorldMap.TILETYPE_ROAD ) return true;
		if( oTile.type_get() == WorldMap.TILETYPE_FOREST ) return true;
		
		return false;
	}
	
}