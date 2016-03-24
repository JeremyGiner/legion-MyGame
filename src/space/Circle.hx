package space;

/**
 * ...
 * @author 
 */
class Circle {
	
	var _oPosition :Vector3;
	var _fRadius :Float;
	
	
	public function new( oPosition :Vector3, fRadius :Float ) {
		if ( oPosition == null )
			_oPosition = new Vector3();
		else
			_oPosition = oPosition;
		_fRadius = Math.max( fRadius, 0 );
	}
	
	public function radius_get():Float {
		return _fRadius;
	}
	
	public function position_get():Vector3 {
		return _oPosition;
	}
	
}