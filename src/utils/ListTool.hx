package utils;

class ListTool{

	static public function merged_get<CValue>( 
		a1 :List<CValue>, 
		a2 :List<CValue> 
	) :List<CValue> {
		var a = new List<CValue>();
		for ( oElem in a1 )
			a.add( oElem );
		for ( oElem in a2 )
			a.add( oElem );
		return a;
	}
	
	/**
	 * Find the index of an element inside a lsit
	 * 
	 * @return -1 if not found else index of the element
	 */
	public static function index_get( l :List<Dynamic>, o :Dynamic ) :Int {
		var i = 0;
		for ( x in l ) {
			if ( x == o ) return i;
			i++;
		}
		return -1;
	}
	
}