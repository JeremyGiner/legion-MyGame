package mygame.game.ability;

import legion.ability.IAbility;
import mygame.game.entity.Unit;
import mygame.game.entity.WorldMap;
import mygame.game.tile.Tile;
import space.Vector2i;
import space.Vector3 in Vector2;

class Position extends Vector2i implements IAbility {
	
	var _oWorldMap :WorldMap;
	var _oUnit :Unit;
	
	// Calculable
	var _oTile :Tile;
	
//______________________________________________________________________________
//	Constructor

	public function new( oUnit :Unit, oWorldMap :WorldMap, x_ :Int, y_ :Int ) :Void {
		_oUnit = oUnit;
		_oWorldMap = oWorldMap;
		super( x_, y_ );
	}

//______________________________________________________________________________
//	Accessor

	override public function set( x_:Int, y_:Int = 0 ){
		x = x_;
		y = y_;
		
		_oTile = _oWorldMap.tile_get_byUnitMetric( x, y );
		
		return this;
	}
	
	public function tile_get() { return _oTile; }
	public function map_get() { return _oWorldMap; }
	
	public function dispose() {
		
	}
	
	public function unit_get() { return _oUnit; }

	
	public function mainClassName_get() {
		return Type.getClassName( Type.getClass( this ) );
	}
	
//_____________________________________________________________________________
//	Utils

	public static function metric_unit_to_maptile( i :Int ) :Int {
		return Math.floor( i/10000 );
	}
	public static function metric_unit_to_map( i :Int ) :Float {
		return i/10000;
	}
	public static function metric_unit_to_map_vector( oVector :Vector2i ) {
		return new Vector2( oVector.x/10000, oVector.y/10000 );
	}
	
	public static function metric_map_to_unit( i :Int ) :Int {
		return i*10000;
	}
	public static function metric_map_to_unit_vector( oVector :Vector2 ) {
		return new Vector2i( Math.round(oVector.x*10000), Math.round(oVector.y*10000) );
	}

}