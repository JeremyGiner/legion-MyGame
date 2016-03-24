package space;


class AlignedAxisBox2i implements IAlignedAxisBoxi {
	
	var _fHalfWidth :Int;
	var _fHalfHeight :Int;
	var _oPosition :Vector2i;
	
//______________________________________________________________________________
//	Cosntructor

	public function new(
		fHalfWidth :Int,
		fHalfHeight :Int,
		oPosition :Vector2i = null
	) {
		_fHalfWidth = fHalfWidth;
		_fHalfHeight = fHalfHeight;
		if( oPosition == null )
			_oPosition = new Vector2i();
		else
			_oPosition = oPosition;
	}
	
//______________________________________________________________________________
//	Accessor
	
	public function center_get() { return _oPosition; };
	
	public function halfWidth_get() { return _fHalfWidth; };
	public function width_get() { return _fHalfWidth*2; };
	
	public function height_get() { return _fHalfHeight*2; };
	public function halfHeight_get() { return _fHalfHeight; };
	
	public function top_get() { return _oPosition.y+_fHalfHeight; }
	public function bottom_get() { return _oPosition.y-_fHalfHeight; }
	public function right_get() { return _oPosition.x+_fHalfWidth; }
	public function left_get() { return _oPosition.x-_fHalfWidth; }
}