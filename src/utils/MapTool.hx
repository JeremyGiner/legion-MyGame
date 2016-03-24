package utils;

import haxe.ds.IntMap;

//WIp
class MapTool {
	/*
	static public function getSortedMap( oMap :Map<Dynamic> ) {
		var oMap = getJoinedMap( oMap, [] );
		
		for (int i = (ar.length - 1); i >= 0; i--) {
			for (int j = 1; j <= i; j++) {
				if (ar[j-1] > ar[j]) {
					int temp = ar[j-1];
					ar[j - 1] = ar[j];
					ar[j] = temp;
				}
			}
		}
		
	}*/
	
	/**
	 * 
	 */
	static public function getMergedIntMap<CValue>( 
		oMap1 :IntMap<CValue>, 
		oMap2 :IntMap<CValue> 
	) :IntMap<CValue> {
		var oMap = new IntMap<CValue>();
		for ( oKey in oMap1.keys() )
			oMap.set( oKey, oMap1.get(oKey) );
		for ( oKey in oMap2.keys() )
			oMap.set( oKey, oMap2.get(oKey) );
		return oMap;
	}
	
	/**
	 * 
	 */
	static public function toList<CValue>( 
		oMap :IntMap<CValue>
	) {
		var l = new List<CValue>();
		
		for ( e in oMap ) {
			l.add( e );
		}
		
		return l;
	}
}