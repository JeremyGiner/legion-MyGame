package mygame.game.entity;

/*
 * Requirement : 
 * max size, player start position, 1
 */

import legion.Game;
import legion.entity.Entity;
import mygame.game.tile.Tile;
import mygame.game.tile.*;

import space.Vector3;

class WorldMap extends Entity {

	var _iSizeX :Int = 10;
	var _iSizeY :Int = 10;
	
	var _aoTile :Array<Array<Tile>>;
	
	public static inline var TILETYPE_SEA = 0;
	public static inline var TILETYPE_GRASS = 1;
	public static inline var TILETYPE_FOREST = 2;
	public static inline var TILETYPE_MOUNTAIN = 3;
	public static inline var TILETYPE_ROAD = 4;

//_____________________________________________________________________________
// Constructor

	public function new( oGame :Game ){
		super( oGame );
		
		/*_aoTile = new Array<Array<Tile>>();
		
		for( i in 0...10 ){
			_aoTile[i] = new Array<Tile>();
			for( j in 0...10 ){
				_aoTile[i][j] = new Tile( i, j );
			}
		}*/
	}
	
	public static function load( oData :Dynamic, oGame :Game ){
		//TODO : check oData
		var oWorldMapTmp = new WorldMap( oGame );
		
		oWorldMapTmp._iSizeX = oData.iSizeX;
		oWorldMapTmp._iSizeY = oData.iSizeY;
		
		oWorldMapTmp._aoTile = new Array<Array<Tile>>();
		for( i in 0...oWorldMapTmp._iSizeX ){
		
			oWorldMapTmp._aoTile[i] = new Array<Tile>();
			
			for( j in 0...oWorldMapTmp._iSizeY ){
			
				switch( oData.aoTile[j][i] ){
					case 0 : oWorldMapTmp._aoTile[i][j] = new Sea( oWorldMapTmp, i, j );
					case 1 : oWorldMapTmp._aoTile[i][j] = new Grass( oWorldMapTmp, i, j );
					case 2 : oWorldMapTmp._aoTile[i][j] = new Forest( oWorldMapTmp, i, j );
					case 3 : oWorldMapTmp._aoTile[i][j] = new Mountain( oWorldMapTmp, i, j );
					case 4 : oWorldMapTmp._aoTile[i][j] = new Road( oWorldMapTmp, i, j );
				}
				
			}
		}
		
		mirrorY( oWorldMapTmp );
		
		return oWorldMapTmp;
	}
		

// ____________________________________________________________________________
//	Accessor
	
	public function sizeX_get():Int{ return _iSizeX; }
	public function sizeY_get():Int{ return _iSizeY; }
	
	public function tile_get( x :Int, y :Int ) :Tile {
		if( x<0 || y<0 || x>=_iSizeX || y>=_iSizeY )
			return null;
		return _aoTile[x][y];
	}
	
	public function tile_get_byVector( oPosition :Vector3 ) :Tile {
		return tile_get( 
			Math.floor( oPosition.x ), 
			Math.floor( oPosition.y ) 
		);
	}
	
	public function tile_get_byUnitMetric( x :Int, y :Int ) :Tile {
		return tile_get( 
			Math.floor( x / 10000 ), 
			Math.floor( y / 10000 ) 
		);
	}
	
// ____________________________________________________________________________
//	Misc


	public function tileList_gather( oParent :Tile ) {
		var loTile = new List<Tile>();
		loTile.add( oParent );
		
		var oTile :Tile = null;
		for( i in 0...8 ) {
			switch( i ) {
				case 0 : oTile = tile_get( oParent.x_get()+1, oParent.y_get() );
				case 1 : oTile = tile_get( oParent.x_get()+1, oParent.y_get()+1 );
				case 2 : oTile = tile_get( oParent.x_get(), oParent.y_get()+1 );
				case 3 : oTile = tile_get( oParent.x_get()-1, oParent.y_get()+1 );
				case 4 : oTile = tile_get( oParent.x_get()-1, oParent.y_get() );
				case 5 : oTile = tile_get( oParent.x_get()-1, oParent.y_get()-1 );
				case 6 : oTile = tile_get( oParent.x_get(), oParent.y_get()-1 );
				case 7 : oTile = tile_get( oParent.x_get()+1, oParent.y_get()-1 );
			}
			if( oTile != null )
				loTile.add( oTile );
		}
		return loTile;
	}
	
	public function tileList_get_byArea( 
		xMin :Int, xMax :Int, 
		yMin :Int, yMax :Int 
	) {
		var loTile = new List<Tile>();
		var oTile :Tile = null;
		
		for( x in xMin...(xMax+1) ) {
			for( y in yMin...(yMax+1) ) {
				oTile = tile_get( x, y );
				if( oTile != null )
					loTile.add( oTile );
			}
		}
		return loTile;
	}
	

	static function mirrorY( oWorldMap :WorldMap ) {
		for ( i in 0...oWorldMap._iSizeX ) {
			for( j in 0...oWorldMap._iSizeY ) {
				var oTile = oWorldMap._aoTile[i][j];
				var iSize = oWorldMap.sizeY_get() * 2-1;
				oWorldMap._aoTile[i][iSize-j] = new Tile( oWorldMap, i, iSize-j, oTile.z_get(), oTile.type_get() );
			}
		}
		oWorldMap._iSizeY *= 2;
	}
	
	

}