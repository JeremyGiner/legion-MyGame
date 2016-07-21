package mygame.client.view.visual.entity;

import js.three.*;
import mygame.client.view.visual.EntityVisual;
import mygame.client.view.GameView;
import mygame.game.ability.Position;
import mygame.game.tile.Tile;
import mygame.game.tile.*;
import mygame.game.entity.WorldMap;
import mygame.game.query.CityTile;

import Math in HaxeMath;

/**
 * Visual for a WorldMap entity
 */
class WorldMapVisual extends EntityVisual<WorldMap> {

	var _oMap :WorldMap;
	var _oView :GameView;
	
	public static inline var LANDHEIGHT = 0.25;

//______________________________________________________________________________
//	Constructor

	public function new( oDisplayer :GameView, oMap :WorldMap ){
		
		super( oDisplayer, oMap );
	
		_oScene = new Group();
		
		_oMap = oMap;
		_oView = oDisplayer;
		
		// Create mesh
		var oTileTmp :Tile = null;
		for( i in 0..._oMap.sizeX_get() ) {
			for( j in 0..._oMap.sizeY_get() ) {
			
				oTileTmp = _oMap.tile_get( i, j );
			
				var oMesh = new Mesh( 
					geometry_get_byTile( oTileTmp ),
					material_get_byTile( oTileTmp ) 
				);
				oMesh.position.set( i+0.5, j+0.5, oTileTmp.z_get()/8 );// 0 sea level; 2 grass level
				oMesh.receiveShadow = true;
				oMesh.castShadow = true;
				
				_oScene.add( oMesh );
				
				//___________
				// Walls
				var oDelta :Vector2 = new Vector2();
				for( oNeighbor in oTileTmp.neighborList_get() ) {
					if( oTileTmp.z_get() - oNeighbor.z_get() == 2  ) {
					
						// Get angle
						oDelta.set(
							oNeighbor.x_get() - oTileTmp.x_get(),
							oNeighbor.y_get() - oTileTmp.y_get()
						);
						var fAngle = HaxeMath.atan2( oDelta.y, oDelta.x );
						
						// Create wall's mesh
						var oWallMesh :Mesh = new Mesh( 
							_oView.geometry_get( 'wall' ), 
							_oView.material_get( 'tile_slope' ) 
						);
						oWallMesh.rotation.z = fAngle;
						oWallMesh.receiveShadow = true;
						oWallMesh.castShadow = true;
						oMesh.add( oWallMesh );
					}
				}
				
				//_____________________
				// Corner Walls
				// TODO : remove excedent
				var oNeighbor :Tile = null;
				for( i in 0...4 ) {
					switch( i ) {
						case 0 :
							oNeighbor = _oMap.tile_get( 
								oTileTmp.x_get() + 1, 
								oTileTmp.y_get() + 1
							);
						case 1 :
							oNeighbor = _oMap.tile_get( 
								oTileTmp.x_get() - 1, 
								oTileTmp.y_get() + 1
							);
						case 2 :
							oNeighbor = _oMap.tile_get( 
								oTileTmp.x_get() + 1, 
								oTileTmp.y_get() - 1
							);
						case 3 :
							oNeighbor = _oMap.tile_get( 
								oTileTmp.x_get() - 1, 
								oTileTmp.y_get() - 1
							);
				
					}
					if( 
						oNeighbor != null && 
						oTileTmp.z_get() - oNeighbor.z_get() == 2 
					) {
						var fAngle :Float = 0;
						switch( i ) {
							case 0 : fAngle = 180;
							case 1 : fAngle = 90;
							//case 2 : fAngle = 0;
							case 3 : fAngle = -90;
						}
						//fAngle-=90;
						// Get angle
						oDelta.set(
							oNeighbor.x_get() - oTileTmp.x_get(),
							oNeighbor.y_get() - oTileTmp.y_get()
						);
						var fAngle = HaxeMath.atan2( oDelta.y, oDelta.x ) + HaxeMath.PI/4;
						var oWallMesh :Mesh = new Mesh( 
							_oView.geometry_get( 'wall_corner' ), 
							_oView.material_get( 'tile_slope' ) 
						);
						oWallMesh.rotation.z = fAngle;//HaxeMath.PI*fAngle/180;
						//oWallMesh.position.set( 0, 0, 1 );
						oWallMesh.receiveShadow = true;
						oWallMesh.castShadow = true;
						oMesh.add( oWallMesh );
					}
				}
			}
		}
		
		_oScene.updateMatrix();

		_oScene.receiveShadow = true;
		_oScene.castShadow = true;
		
		update();

	}
	
//______________________________________________________________________________
//	Accessor
	
	override public function object3d_get() :Object3D { return _oScene; }
	
	public function tile_get_byVector( oVector :Vector3) :Tile {
		return _oMap.tile_get( 
			Std.int(oVector.x ), 
			Std.int(oVector.y ) 
		);
	}
	
	public function height_get( x :Int, y :Int ) {
		
		// Get tile
		var oTile = this._oMap.tile_get_byUnitMetric( x, y );
		
		if ( oTile == null )
			return LANDHEIGHT;
		
		// Check tile type
		switch( oTile.type_get() ) {
			case WorldMap.TILETYPE_MOUNTAIN :
				// Transpose x;y to the tile center as origin
				var fx = Position.metric_unit_to_map( x );
				var fy = Position.metric_unit_to_map( y );
				fx %= 1;
				fy %= 1;
				var xd = fx - 0.5;
				var yd = fy - 0.5;
				
				return LANDHEIGHT + HaxeMath.max( 
					0,
					LANDHEIGHT*2 - HaxeMath.sqrt( xd * xd + yd * yd )
				);
		}
		
		// Case : city
		if ( _oEntity.game_get().query_get(CityTile).data_get( oTile ).length != 0 ) {
			return 2;
		}
			
		return LANDHEIGHT;
	}
	
//______________________________________________________________________________
//	Updater

	override public function update() {
	
	}
	
//______________________________________________________________________________
//	Utils

	public function geometry_get_byTile( oTile :Tile ) {
		if( oTile.type_get() == WorldMap.TILETYPE_MOUNTAIN ) 
			return _oView.geometry_get( 'mountain' );
		if( oTile.type_get() == WorldMap.TILETYPE_FOREST ) 
			return _oView.geometry_get( 'forest' );
		return _oView.geometry_get( 'tile' );
	}
	public function material_get_byTile( oTile :Tile ) {
		if( oTile.type_get() == WorldMap.TILETYPE_ROAD ) {
		
			/* 	http://www.saltgames.com/2010/a-bitwise-method-for-applying-tilemaps/
			 *  -	1	-
			 * 	8	X	2
			 * 	-	4	-
			 */
			var i :Int = 0;
			var oMap :WorldMap = oTile.map_get();
			if( oMap.tile_get( oTile.x_get(), oTile.y_get() + 1 ).type_get() == WorldMap.TILETYPE_ROAD ) {
				i += 1; 
			}
			if( oMap.tile_get( oTile.x_get() + 1, oTile.y_get() ).type_get() == WorldMap.TILETYPE_ROAD ) {
				i += 2; 
			}
			if( oMap.tile_get( oTile.x_get(), oTile.y_get() - 1 ).type_get() == WorldMap.TILETYPE_ROAD ) {
				i += 4;
			}
			if( oMap.tile_get( oTile.x_get() - 1, oTile.y_get() ).type_get() == WorldMap.TILETYPE_ROAD ) {
				i += 8;
			}
			
			switch( i ) {
				case 5 : return _oView.material_get( 'tile_road_NS' );	//NS
				case 10 : return _oView.material_get( 'tile_road_WE' );	//WE
				case 3 : return _oView.material_get( 'tile_road_NE' );	//turn NE
				case 6 : return _oView.material_get( 'tile_road_SE' );	//turn SE
				case 12 : return _oView.material_get( 'tile_road_SW' );	//turn SW
				case 9 : return _oView.material_get( 'tile_road_NW' );	//turn NW
			}
			return _oView.material_get( 'tile_road_cross' );
		}
		if( oTile.type_get() == WorldMap.TILETYPE_MOUNTAIN ) return _oView.material_get( 'worldmap' );
		if( oTile.type_get() == WorldMap.TILETYPE_FOREST ) return _oView.material_get( 'tile_forest' );
		if( oTile.type_get() == WorldMap.TILETYPE_GRASS ) return _oView.material_get( 'tile_grass' );
		//if( Std.is( oTile, Grass) ) return _oView.material_get( 'basic_red' );
		return _oView.material_get( 'tile_sea' );
	}

}