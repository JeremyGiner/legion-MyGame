package space;


class AlignedAxisBoxAlti implements IAlignedAxisBoxi {
	
	var _iWidth :Int;
	var _iHeight :Int;
	var _oBottomLeft :Vector2i;
	
//______________________________________________________________________________
//	Cosntructor

	public function new(
		iWidth :Int,
		iHeight :Int,
		oBottomLeft :Vector2i = null
	) {
		_iWidth = iWidth;
		_iHeight = iHeight;
		if( oBottomLeft == null )
			_oBottomLeft = new Vector2i();
		else
			_oBottomLeft = oBottomLeft;
	}
	
//______________________________________________________________________________
//	Accessor
	
	public function width_get() { return _iWidth; };
	public function height_get() { return _iHeight; };
	
	public function haliWidth_get() { return _iWidth/2; };
	public function haliHeight_get() { return _iHeight/2; };
	
	public function top_get() { return _oBottomLeft.y + _iHeight; }
	public function bottom_get() { return _oBottomLeft.y; }
	public function right_get() { return _oBottomLeft.x + _iWidth; }
	public function left_get() { return _oBottomLeft.x; }
	
	public function bottomLeft_set( x :Int, y :Int ) {
		_oBottomLeft.set( x, y );
	}
}