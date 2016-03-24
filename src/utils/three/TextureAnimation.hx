package utils.three;

import js.three.*;

// extends Texture?
class TextureAnimation {
	var _iGridCellQ :Int;
	var _fCellSizeU :Flaot;
	var _fCellSizeV :Float;
	var _fGridOffsetU :Float; 
	var _fGridOffsetV :Float; 
	var _oTexture :Texture;
	var _oTimer :Timer;
	
//______________________________________________________________________________
// Constructor

	public function new( 
		oTexture :Texture,
		oTimer :Timer, 
		iGridCellQX :Int,
		fGridOffsetU :Float = 0.0, 
		fGridOffsetV :Float = 0.0
		
	){
		_oTexture = oTexture;
		//TODO : get _iGridSizeU & _iGridSizeV n'stuff
		_oTimer = oTimer;
	}
	
//______________________________________________________________________________

	public function update(){
	
		var x :Float;
		var i :Int;
		
		//Getting cell percent size
		x = 1 / _iGridCellQ;
		
		//Getting current cell index
		i = Math.round( _oTimer.expirePercent_get() / x );
		
		//Update texture offset to match cell index
		_oTexture.offset.x
	}

	private function cellU_get:Float( x :Int ){ return _fCellSizeU*x + _fGridOffsetU; }
	private function cellV_get:Float( y :Int ){ return _fCellSizeV*x + _fGridOffsetV; }
}