package utils;

import Array;

class Array2<CValue> /*extends Array<CValue>*/ {
	private var pitch :Int;
	
	private var _aoArray :Array<CValue>;
	
	public function new( x: Int ) { 
		pitch = x; 
		//super();
		_aoArray = new Array<CValue>();
	} 
	
	public function get(x: Int, y: Int) { 
		return _aoArray[x + y*pitch]; 
	}
	public function set( x: Int, y: Int, oValue :CValue ) { 
		_aoArray[x + y*pitch] = oValue; 
	}
	
	public function pitch_get() { return pitch; }
}