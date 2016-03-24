package utils;

/**
 * Universal disposer. Take an object and put all his fields to null.
 * @author GINER Jérémy
 */
class Disposer {

	
	public function new() {
		
	}
	
	
	static public function dispose( o :Dynamic ) {
		if( o == null ) throw('[ERROR]:Disposer:dispose:o is null.');
		for( oField in Reflect.fields( o ) ) {
			Reflect.setField( o, oField, null );
		}
	}
}