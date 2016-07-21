package space;

import Math;
/**
 * TODO: find a way to compile this
 */
class Vector2<CNum> {
	public var x :CNum;
	public var y :CNum;

//_____________________________________________________________________________
//	Constructor

	public function new( x_:CNum, y_:CNum){
		set( x_, y_ );
	}
	/*
	public function clone() {
		return new Vector3(x,y);
	}
	public function copy( oVector :Vector2f ){
		return set( oVector.x, oVector.y );
	}
	*/
//_____________________________________________________________________________
//	Accessor

	public function length_get() { 
		return untyped Math.sqrt( x * x + y * y );
	}
	/*
	public function dotProduct( v :Vector2f ) :CNum {
		return( x * v.x + y * v.y );
	}*/

//_____________________________________________________________________________
//	Modifier

	public function set( x_:CNum, y_:CNum ){
		x = x_;
		y = y_;
		
		return this;
	}
	
	public function add( x_:CNum, y_:CNum ){
		x = untyped x + x_;
		y += untyped y_;
		
		return this;
	}
	
	public function mult( fMultiplicator :CNum ) {
		x *= fMultiplicator;
		y *= fMultiplicator;
	}
	
	public function divide( fDivisor :CNum ) {
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
	
	public function length_set( fLength :CNum) {
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