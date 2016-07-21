package space;

import Math;

class Vector2i {
	public var x :Int;
	public var y :Int;

//_____________________________________________________________________________
//	Constructor

	public function new( x_:Int =0, y_:Int=0){
		set( x_, y_ );
	}
	
	public function clone() {
		return new Vector2i(x,y);
	}
	public function copy( oVector :Vector2i ){
		return set( oVector.x, oVector.y );
	}
	
//_____________________________________________________________________________
//	Accessor

	public function length_get() { 
		return Math.sqrt( x * x + y * y );
	}
	
	public function dotProduct( v :Vector2i ) :Float {
		return x * v.x + y * v.y;
	}
	
	public function distance_get( oVector :Vector2i ) {
		return distance( this, oVector );
	}

	public function distanceSqed_get( oVector :Vector2i ) {
		return distanceSqed( this, oVector );
	}
	
//_____________________________________________________________________________
//	Modifier

	public function set( x_:Int, y_:Int = 0 ){
		x = x_;
		y = y_;
		
		return this;
	}
	
	public function add( x_:Int, y_:Int = 0 ){
		x += x_;
		y += y_;
		
		return this;
	}
	
	public function vector_add( oVector :Vector2i ) {
		return add( oVector.x, oVector.y );
	}
	
	public function mult( fMultiplicator :Float ) {
		x = Math.round( x * fMultiplicator );
		y = Math.round( y * fMultiplicator );
		
		return this;
	}
	
	public function divide( fDivisor :Float ) {
		if( fDivisor == 0 ) 
			throw '[ERROR] Vector3 : can not divide by 0.';
		
		return mult( Math.round( 1/fDivisor ) );
	}
	
	public function normalize() {
		divide( length_get() );
		return this;
	}
	
	public function length_set( fLength :Float ) {
		if( fLength < 0 ) throw('Invalid length : '+ fLength);
		var length = length_get();
		if( length == 0 )
			x = Math.round( fLength );
		else
			mult( fLength / length );
			
		return this;
	}
	
	public function project( oVector :Vector2i ) {
		var fDotprod = oVector.dotProduct( this );
		
		this.copy( oVector ).length_set( Math.abs(fDotprod) / oVector.length_get() );
		//this.copy( oVector ).mult( fDotprod / oVector.length_get()² );
		return this;
	}
	
	public function equal( oVector :Vector2i ) {
		return oVector.x == x && oVector.y == y;
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

	public static function distance( v1 :Vector2i, v2 :Vector2i ) {
		var dx = v1.x - v2.x;
		var dy = v1.y - v2.y;
			
		return Math.sqrt( dx * dx + dy * dy );
	}
	public static function distanceSqed( v1 :Vector2i, v2 :Vector2i ) {
		var dx = v1.x - v2.x;
		var dy = v1.y - v2.y;
			
		return dx * dx + dy * dy;
	}
	/**
	 * @source http://gamedev.stackexchange.com/questions/69241/how-to-optimize-the-distance-function
	 * @param	v1
	 * @param	v2
	 */
	public static function distanceOcto( v1 :Vector2i, v2 :Vector2i ) {
		var dx = Math.abs(v1.x - v2.x);
		var dy = Math.abs(v1.y - v2.y);
			
		return (dx + dy + Math.max( dx, dy )) * 0.5;
	}
}