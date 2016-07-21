package mygame.game.ability;

import cloner.Cloner;
import collider.CollisionCheckerPostInt;
import legion.ability.IAbility;
import mygame.game.tile.Tile;
import mygame.game.entity.WorldMap;
import mygame.game.entity.Unit;
import mygame.game.ability.Position;
import space.AlignedAxisBox;
import space.AlignedAxisBox2i;
import space.AlignedAxisBoxAlti;
import space.Vector2i;
import space.Vector3;

class Volume extends UnitAbility {

	var _oPosition :Position;

	var _iHalfSize :Int;	// 10000 = tile size, must be between [0;5000[
	var _fWeight :Float;
	
	var _oHitBox :AlignedAxisBox2i;
	
	var _oVelocity :Vector3;

//______________________________________________________________________________
//	Constructor
	
	public function new( oUnit :Unit, fHalfSize :Int = 2000, fWeight :Float = 1 ) {
		super( oUnit );
		_oPosition = oUnit.ability_get( Position );
		if ( _oPosition == null ) trace('[ERROR]:ability dependency not respected.');
		
		_fWeight = fWeight;
		_iHalfSize = fHalfSize;	
		
		if ( _iHalfSize < 0 || _iHalfSize >= 5000 ) throw 'invalid volume size.';
		
		_oHitBox = new AlignedAxisBox2i( _iHalfSize, _iHalfSize, _oPosition );
		
		_oVelocity = null;
	}

//______________________________________________________________________________
//	Accessor

	public function position_get() {
		return _oPosition;
	}

	public function size_get() :Int { return _iHalfSize; };
	public function weight_get() :Float { return _fWeight; };
	
	public function geometry_get() { return _oHitBox; }
	
	public function tileArray_get() {
		var loTile = _oPosition.map_get().tileList_get_byArea( 
			Math.floor( _oHitBox.left_get()/10000 ), 
			Math.floor( _oHitBox.right_get()/10000 ),
			Math.floor( _oHitBox.bottom_get()/10000 ), 
			Math.floor( _oHitBox.top_get()/10000 )
		);
		
		return loTile;
	}
	
	public function tileList_get() {
		var loTile = _oPosition.map_get().tileList_get_byArea( 
			Math.floor( _oHitBox.left_get()/10000 ), 
			Math.floor( _oHitBox.right_get()/10000 ),
			Math.floor( _oHitBox.bottom_get()/10000 ), 
			Math.floor( _oHitBox.top_get()/10000 )
		);
		
		return loTile;
	}
	
	/**
	 * Retreive the list of tile occupied by this volume 
	 * if it was at a given position
	 */
	public function tileListProject_get( x :Int, y :Int ) {
		
		var oHitBox = new AlignedAxisBox2i( 
			_oHitBox.halfWidth_get(), 
			_oHitBox.halfHeight_get(), 
			new Vector2i(x,y)
		);
		var loTile = _oPosition.map_get().tileList_get_byArea( 
			Math.floor( oHitBox.left_get()/10000 ), 
			Math.floor( oHitBox.right_get()/10000 ),
			Math.floor( oHitBox.bottom_get()/10000 ), 
			Math.floor( oHitBox.top_get()/10000 )
		);
		
		return loTile;
	}
	
	public function positionCorrection( oPoint :Vector2i ) {
		// Case volume
			
		// Get target and neightbor Tile
		var lTile = this.tileListProject_get( oPoint.x, oPoint.y );
		
		// Clamp on target tile
		var oResult = oPoint.clone();
		
		var oUnitGeometry = new AlignedAxisBox2i( 
			this.size_get(), 
			this.size_get(), 
			oPoint 
		);
		
		var oTileGeometry :AlignedAxisBoxAlti;
		for ( oTile in lTile ) {
			// Filter walkable and non colling tile
			if ( this.unit_get().ability_get(PositionPlan).validate( oTile ) ) 
				continue;
			
			// Build up tile geometry
			oTileGeometry = Tile.tileGeometry_get( oTile );
			
			// Filter non colling tile
			if ( 
				!CollisionCheckerPostInt.check( 
					oUnitGeometry,
					oTileGeometry
				)
			) 
				continue;
			
			//_____
			var iVolumeSize = this.size_get();
			var dx :Float = oPoint.x/10000 - (oTile.x_get()+0.5);
			var dy :Float = oPoint.y/10000 - (oTile.y_get()+0.5);
			if ( Math.abs(dx) > Math.abs(dy) )
				// Clamp on X axis
				oResult.x = ( dx > 0 ) ?
					oTileGeometry.right_get() + 1 + iVolumeSize : 
					oTileGeometry.left_get()-1 - iVolumeSize;
			else
				// Clamp on Y axis
				oResult.y = ( dy > 0 ) ?
					oTileGeometry.top_get() + 1 + iVolumeSize : 
					oTileGeometry.bottom_get()-1 - iVolumeSize;
		}
		return oResult;
	}
	
}