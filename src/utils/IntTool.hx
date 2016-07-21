package utils;

/**
 * ...
 * @author GINER Jérémy
 */
class IntTool {
	
	static public inline var MAX :Int = 0x3FFFFFFF;

	static public function min( a :Int, b :Int ) {
		//return ( a >  b )? a : b;
		if ( a >  b )
			return b;
		return a;
	}
	static public function max( a :Int, b :Int ) {
		//return ( a >  b )? a : b;
		if ( a <  b )
			return b;
		return a;
	}
	static public function abs( a :Int ) {
		//return ( a >  b )? a : b;
		if ( a <  0 )
			return -a;
		return a;
	}
}