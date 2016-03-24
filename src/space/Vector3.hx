package space;

import Math;

class Vector3 {
	public var x :Float;
	public var y :Float;
	public var z :Float;

//_____________________________________________________________________________
//	Constructor

	public function new( x_:Float =0, y_:Float=0, z_:Float=0){
		set( x_, y_, z_);
	}
	
	public function clone() {
		return new Vector3(x,y,z);
	}
	public function copy( oVector :Vector3 ){
		set( oVector.x, oVector.y, oVector.z );
	}
	
//_____________________________________________________________________________
//	Accessor

	public function set( x_:Float, y_:Float = 0, z_:Float = 0 ){
		x = x_;
		y = y_;
		z = z_;
		
		return this;
	}
	
	public function add( x_:Float = 0, y_:Float = 0, z_:Float = 0 ){
		x += x_;
		y += y_;
		z += z_;
		
		return this;
	}
	
	public function mult( fMultiplicator :Float ) {
		x *= fMultiplicator;
		y *= fMultiplicator;
		z *= fMultiplicator;
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
	public function length_get() { 
		return Math.sqrt( x * x + y * y + z * z );
	}
	
	public function dotProduct( v :Vector3 ) :Float {
		return( x * v.x + y * v.y + z * v.z );
	}
//_____________________________________________________________________________
//	Shortcut

	public function vector3_add( oVector :Vector3 ) {
		this.add( oVector.x, oVector.y, oVector.z );
	}
	public function vector3_sub( oVector :Vector3 ) {
		this.add( -oVector.x, -oVector.y, -oVector.z );
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

	public static function distance( v1 :Vector3, v2 :Vector3 ) {
		var dx = v1.x - v2.x;
		var dy = v1.y - v2.y;
		var dz = v1.z - v2.z;
			
		return Math.sqrt( dx * dx + dy * dy + dz * dz );
	}
}