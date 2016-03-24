package mygame.game.ability;

import cloner.Cloner;
import legion.ability.IAbility;
import mygame.game.tile.Tile;
import mygame.game.entity.WorldMap;
import mygame.game.entity.Unit;
import mygame.game.ability.Position;
import space.AlignedAxisBox;
import space.AlignedAxisBox2i;
import space.Vector2i;
import space.Vector3;

class Volume extends UnitAbility {

	var _oPosition :Position;

	var _iHalfSize :Int;	// 1 = tile size, must be between [0;5000[
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
	
//______________________________________________________________________________
//	Modifier

	//TODO
	public function move() {
		/*
	// Check velocity
		if( _oVelocity == null )
			return;
	
	// Get direction vector
		var oVector = _oVelocity.clone();
		oVector = _oVelocity.clone();
	
	// Apply speed
		if( oVector.length_get() > _fSpeed )
			oVector.length_set( _fSpeed );
		oVector.add( _oPosition.x, _oPosition.y );
		
	// Update position
		_position_set( oVector.x, oVector.y );
		*/
	}
}