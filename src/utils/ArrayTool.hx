package utils;

import haxe.ds.IntMap;

//WIp
class ArrayTool {
	
	static public function getMerged<CValue>( 
		a1 :Array<CValue>, 
		a2 :Array<CValue> 
	) :Array<CValue> {
		var a = new Array<CValue>();
		for ( oElem in a1 )
			a.push( oElem );
		for ( oElem in a2 )
			a.push( oElem );
		return a;
	}
}