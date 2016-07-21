package mygame.game.utils;

import haxe.ds.StringMap;
import space.Vector3 in Vector2;
import space.Vector3;
import utils.IntTool;
import utils.ListTool;

import mygame.game.tile.Tile;
import mygame.game.tile.*;
import mygame.game.entity.WorldMap;

/**
 * ...
 * @author GINER Jérémy
 */
class PathFinderFlowField {

	var _oWorldMap :WorldMap;
	
	var _aHeatMap :StringMap<Int>;
	var _aReferenceMap :StringMap<Tile>;

	var _lTileCurrent :List<Tile>;	//Remain of last computation
	
	var _pTest :IValidatorTile;
	
	//var _bSuccess :Bool;
	
	// Calculable

//_____________________________________________________________________________
//	Constructor

	public function new( 
		oWorldMap :WorldMap,
		//lPosition :List<Tile>, 
		lDestination :List<Tile>, 
		pTest :IValidatorTile 
	) {	
		_oWorldMap = oWorldMap;
		
		_aReferenceMap = new StringMap<Tile>();
		_aHeatMap = new StringMap<Int>();
		_lTileCurrent = new List<Tile>();
		
		_pTest = pTest;
		
		// Mark end tile
		for ( oTile in lDestination ) {
			// Mark end tiles with themself
			_aReferenceMap.set( _key_get( oTile ), oTile );
			_aHeatMap.set( _key_get( oTile ), 0 );
			_lTileCurrent.push( oTile );
			
			//lPosition.remove( oTile );	//TODO modify a copy
		}
		
		// 
		//_bSuccess = _referenceMap_update( lPosition );
	}

//_____________________________________________________________________________
//	Accessor
	
	public function worldmap_get() { return _oWorldMap; }

	//public function success_check() { return _bSuccess; }
	
	public function refTile_getbyCoord( x :Int, y :Int ) {
		if ( _aReferenceMap == null )
			return null;
		
		return _aReferenceMap.get( x+';'+y );
	}
	public function refTile_get( oTile :Tile ) {
		if ( _aReferenceMap == null )
			return null;
		
		_update( oTile );
		
		return _aReferenceMap.get( _key_get( oTile ) );
	}
	
	// TODO : remove the other get
	public function heat_get_byTile( oTile :Tile) {
		if ( oTile == null ) 
			return IntTool.MAX;
		
		_update( oTile );
		
		return _aHeatMap.get( _key_get( oTile ) );
	}
	
//_____________________________________________________________________________
//	Modifier
	
	
	/**
	 * Quick fix, allow to edit ref map
	 * @param	oTile
	 * @param	oTileRef
	 * 
	 */
	public function refTile_set( oTile :Tile, oTileRef :Tile ) {
		if( _aReferenceMap.get( _key_get( oTile ) ) == null )
			throw 'nasty';
		_aReferenceMap.set( _key_get( oTile ), oTileRef );
	}
	
	
	
//_____________________________________________________________________________
//	Sub-routine
	
	function _update( oTile ) {
		// Check if need update
		if ( _aReferenceMap.exists( _key_get( oTile ) ) ) 
			return;	// Already accessible
		
		// Update
		var l = new List<Tile>();
		l.add( oTile );
		_referenceMap_update( l );
	}

	function _key_get( oTile :Tile ) {
		return oTile.x_get() + ';' + oTile.y_get();
	}
	
	function _referenceMap_update(
		lTileStart :List<Tile>
	) :Bool {
		
		var lTileStartRemaining = ListTool.merged_get( lTileStart, new List<Tile>() );	// Shallow copy
		
		//Explore simultaneously every possible path, stop on the first (and therefore shortest) found
		var oTileParent :Tile;
		var oTileChild :Tile;

		while( !_lTileCurrent.isEmpty() ){
			oTileParent = _lTileCurrent.pop();
			
			// Create reference for each valid child tile
			for( oTileChild in _tileChild_get( oTileParent ) ) {
				if( oTileChild != null && Std.is(oTileChild,Tile ))	// Necessary?
				if( _pTest.validate( oTileChild ) )
				if( _aReferenceMap.get( _key_get( oTileChild ) ) == null ) {
				
					_aReferenceMap.set( _key_get(oTileChild), oTileParent );
					_aHeatMap.set( 
						_key_get( oTileChild ), 
						_aHeatMap.get( _key_get( oTileParent ) ) +1
					);
					
					_lTileCurrent.add( oTileChild );
				} else {
					// Multi Path case -> get tile at the intersection of both reference
					
					var oPrevRef = refTile_get( oTileChild );
					var oNewRef = oTileParent;
					
					// Check heat, discard path with superior heat
					if( heat_get( oNewRef ) > heat_get( oPrevRef ) )
						continue;
					
					// Resolution for 2 possible path
					var oPrevRefRef = refTile_get( oPrevRef );
					var oNewRefRef = refTile_get( oNewRef );
					
					// TODO : improve perf
					
					// TODO : replace with proper code, from lib space ?
					var v = _line_intersect(
						oNewRef.x_get(), oNewRef.y_get(),
						oNewRefRef.x_get(), oNewRefRef.y_get(),
						oPrevRef.x_get(), oPrevRef.y_get(),
						oPrevRefRef.x_get(), oPrevRefRef.y_get()
					);
					
					// Skip if doesn't cross
					if ( v == null ) continue;
					
					// Check if cross on the right direction
					var oVectorTmp = new Vector3(
						v.x - oNewRef.x_get(), 
						v.y - oNewRef.y_get()
					);
					
					if ( 
						oVectorTmp.dotProduct( 
							new Vector3(
								oNewRefRef.x_get() - oNewRef.x_get(),
								oNewRefRef.y_get() - oNewRef.y_get()
							) 
						) < 0
					) continue;
					
					// Get cross-reference tile
					var t = _oWorldMap.tile_get(
							Math.floor( v.x ),
							Math.floor( v.y )
						);
					
					// Debug case
					if ( 
						t == null ||
						!_pTest.validate( t ) ||
						t == oTileChild	//TODO: debug purpose only, should not occur
					) {
						continue;
						throw 'NOT OK';
						throw 'NOT OK';
					}
					
					// Apply newly found reference
					_aReferenceMap.set( 
						_key_get( oTileChild ),
						t
					);
				}
			}
			
			// Try to remove current tile from the "must found" list
			// Using while in case multiple occurence of the same instance exist
			while( lTileStartRemaining.remove( oTileParent ) ){};
			
            if ( lTileStartRemaining.isEmpty() ) {
				// All found -> Success
				return true;
			}
		}
		
		trace("[ERROR] : Pathfinder : no PATH found\n");
		return false;
	}
	
	/**
	 * Retrieve neighbor tiles
	 * @param	oTileParent
	 */
	function _tileChild_get( oTileParent :Tile ) {
		
		return [
			_oWorldMap.tile_get( oTileParent.x_get()+1,oTileParent.y_get()),
			_oWorldMap.tile_get( oTileParent.x_get()-1,oTileParent.y_get()),
			_oWorldMap.tile_get( oTileParent.x_get(),oTileParent.y_get()+1),
			_oWorldMap.tile_get( oTileParent.x_get(),oTileParent.y_get()-1),
		].filter( function(oTile) { return oTile != null; } );
	}

	
	//TODO: remove
	function heat_get( oTile :Tile ) {
		return _aHeatMap.get( _key_get( oTile ) );
	}

//_____________________________________________________________________________
//	
	
	// TODO: find better name
	public function refMapDiff_get(  x :Int, y :Int  ) {
		var v = new Vector2();
		v.x = _aReferenceMap.get( x+';'+y ).x_get() - x;	//ref tile position - current tile position
		v.y = _aReferenceMap.get( x+';'+y ).y_get() - y;
		return v;
	}
	

	
//______________________________________________________________________________
//	Other

	// Source : http://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
	// doesn't work with : 8,8, 9,2, 7,7, 8,4 -> 9.333333,0
	function _line_intersect( 
		x1 :Int, y1 :Int, 
		x2 :Int, y2 :Int, 
		x3 :Int, y3 :Int, 
		x4 :Int, y4 :Int
	) {
		var a = x1 * y2 - y1 * x2;	//	8*2-8*9 = 16-72 = -56
		var dX34 = x3 - x4;			//	7-8 = -1
		var dX12 = x1 - x2;			//	8-9 = -1
		var d = x3 * y4 - y3 * x4;	//	7*4-7*8 = 28 - 56 = -28
		var dy34 = y3 - y4;			//	7-4 = 3
		var dy12 = y1 - y2;			//	8-2 = 6
		var g = dX12 * dy34 - dy12 * dX34;	//	(-1*-3) - (6*-1) = 3+6 = 9
		
		// if parallele
		if ( g == 0 )
			return null;
			
		var v = new Vector2();
		
		v.x = ( a * dX34 - dX12 * d ) / g;	//	
		v.y = ( a * dy34 - dy12 * d ) / g;	//	(-56*3) - (6*-28) / 9 =  -168 + 168) / 9 = 0
		
		return v;
	}
}

