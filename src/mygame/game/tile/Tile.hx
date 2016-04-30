package mygame.game.tile;

import math.Limit;
import mygame.game.entity.WorldMap;
import space.AlignedAxisBoxAlt;
import space.AlignedAxisBoxAlti;
import space.Vector2i;

class Tile{
	
	var _oMap :WorldMap;
	var _x :Int;
	var _y :Int;
	var _z :Int;
	
	var _iType :Int;
	
	//static var _oHitBox = { new AlignedAxisBoxAlt( 1, 1 ); };	// TODO: fix float proximation
	
//______________________________________________________________________________
//	Constructor
	
	public function new( oMap :WorldMap, x :Int, y :Int, z :Int, iType :Int ){
		_x = x;
		_y = y;
		_z = z;
		_iType = iType;
		_oMap = oMap;
		
	}
//______________________________________________________________________________
//	Accessor

	public function x_get(){ return _x; }
	public function y_get(){ return _y; }
	public function z_get() { return _z; }
	public function type_get(){ return _iType; }
	public function map_get(){ return _oMap; }
	
	public function neighborList_get() :List<Tile> {
		var loTile :List<Tile> = new List<Tile>();
		var oTile :Tile = null;
		for( i in 0...4 ) {
			switch( i ){
				case 0 : oTile = _oMap.tile_get( this.x_get()+1,this.y_get());
				case 1 : oTile = _oMap.tile_get( this.x_get()-1,this.y_get());
				case 2 : oTile = _oMap.tile_get( this.x_get(),this.y_get()+1);
				case 3 : oTile = _oMap.tile_get( this.x_get(),this.y_get()-1);
			}
			if( oTile != null )
				loTile.push( oTile );
		}
			
		return loTile;
	}
	
	static public function tileGeometry_get( oTile :Tile ) {
		return new AlignedAxisBoxAlti(
			9999, 
			9999, 
			new Vector2i(
				oTile.x_get() * 10000,
				oTile.y_get() * 10000
			) 
		);
	}

}