package space;

import Math;

class Vector2f {
	public var x :Float;
	public var y :Float;

//_____________________________________________________________________________
//	Constructor

	public function new( x_:Float =0, y_:Float=0){
		set( x_, y_ );
	}
	
	public function clone() {
		return new Vector3(x,y);
	}
	public function copy( oVector :Vector2f ){
		return set( oVector.x, oVector.y );
	}
	
//_____________________________________________________________________________
//	Accessor

	public function length_get() { 
		return Math.sqrt( x * x + y * y );
	}
	
	public function dotProduct( v :Vector2f ) :Float {
		return( x * v.x + y * v.y );
	}

//_____________________________________________________________________________
//	Modifier

	public function set( x_:Float, y_:Float = 0 ){
		x = x_;
		y = y_;
		
		return this;
	}
	
	public function add( x_:Float = 0, y_:Float = 0 ){
		x += x_;
		y += y_;
		
		return this;
	}
	
	public function mult( fMultiplicator :Float ) {
		x *= fMultiplicator;
		y *= fMultiplicator;
	}
	
	public function divide( fDivisor :Float ) {
		if( fDivisor != 0 ) {
			mult( 1/fDivisor );
		} else {
			throw '[ERROR] Vector3 : can not divide by 0.';
		}
	}
	
	public function normalize() {
		divide( length_get() );
		return this;
	}
	
	public function length_set( fLength :Float) {
		if( fLength < 0 ) throw('Invalid length : '+ fLength);
		var length = length_get();
		if( length == 0 )
			x = fLength;
		else
			mult( fLength / length );
			
		return this;
	}
	
	public function project( oVector :Vector2f ) {
		var fDotprod = oVector.dotProduct( this );
		
		this.copy( oVector ).length_set( Math.abs(fDotprod) / oVector.length_get() );
		
		return this;
	}
	
//_____________________________________________________________________________
//	Shortcut

	public function vector_add( oVector :Vector2f ) {
		this.add( oVector.x, oVector.y );
	}
	
//_____________________________________________________________________________
//
	//Result range :  [-Math.PI / 2, Math.PI / 2] 
	public function angleAxisXY(){
		if( x == 0 && y == 0 )
			return null;
		return Math.atan2( y, x );
	}
//_____________________________________________________________________________
//	Static

	public static function distance( v1 :Vector2f, v2 :Vector2f ) {
		var dx = v1.x - v2.x;
		var dy = v1.y - v2.y;
			
		return Math.sqrt( dx * dx + dy * dy );
	}
}