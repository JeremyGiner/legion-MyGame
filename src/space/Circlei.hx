package space;

import utils.IntTool;

/**
 * ...
 * @author 
 */
class Circlei {
	
	var _oPosition :Vector2i;
	var _fRadius :Int;
	
	
	public function new( oPosition :Vector2i, iRadius :Int ) {
		if ( oPosition == null )
			_oPosition = new Vector2i();
		else
			_oPosition = oPosition;
		_fRadius = IntTool.max( iRadius, 0 );
	}
	
	public function radius_get():Int {
		return _fRadius;
	}
	
	public function position_get():Vector2i {
		return _oPosition;
	}
	
}