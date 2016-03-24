package utils;

class Utils{

	public function pairing( aIn :Array<Dynamic> ):Array<Dynamic>{

		// TODO : test with a concat algorithm
		// TODO : extends list or array

		/*
			j\i[0][1][2]...
			[0] -  x  x
			[1] -  -  x
			[2] -  -  -
			...
		*/
		aResult = new Array<Thing>();
		
		// Check param
		if( aIn.length < 2 ) return aResult;
		//if( aIn.length = 2 ) return new Array<Thing>( aIn[0], aIn[1] );
		
		// Pairing
		for( i = 1; i < aIn.length; i++ ){
			for( j = 0; j < i; j++ ){
				aResult.push( aIn[i] );
				aResult.push( aIn[j] );
			}
		}

		return aResult;
	}
}