package space;

import space.Vector3 in Vector2;


class AlignedAxisBoxAlt implements IAlignedAxisBox {
	
	var _fWidth :Float;
	var _fHeight :Float;
	var _oBottomLeft :Vector2;
	
//______________________________________________________________________________
//	Cosntructor

	public function new(
		fWidth :Float,
		fHeight :Float,
		oBottomLeft :Vector3 = null
	) {
		_fWidth = fWidth;
		_fHeight = fHeight;
		if( oBottomLeft == null )
			_oBottomLeft = new Vector3();
		else
			_oBottomLeft = oBottomLeft;
	}
	
//______________________________________________________________________________
//	Accessor
	
	public function center_get() { 
		return new Vector2( 
			_oBottomLeft.x + halfWidth_get(),  
			_oBottomLeft.y + halfHeight_get()
		);
	}
	
	public function width_get() { return _fWidth; };
	public function height_get() { return _fHeight; };
	
	public function halfWidth_get() { return _fWidth/2; };
	public function halfHeight_get() { return _fHeight/2; };
	
	public function top_get() { return _oBottomLeft.y+_fHeight; }
	public function bottom_get() { return _oBottomLeft.y; }
	public function right_get() { return _oBottomLeft.x+_fWidth; }
	public function left_get() { return _oBottomLeft.x; }
	
	public function bottomLeft_set( x :Float, y:Float ) {
		_oBottomLeft.set( x, y );
	}
}