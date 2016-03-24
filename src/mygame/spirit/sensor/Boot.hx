package mygame.spirit.sensor;

/**
 * 
 * 
 * @author GINER Jérémy
 */
class Boot implements ISensor {

	public function new() {
		
	}

//_____________________________________________________________________________
// Accessor
	
	public function resolution_get() { return 0; }
	public function value_get() :Array<Float> {
		var a = new Array<Float>();
		a.push( 1 );
		return a;
	}
	public function mask_get() :Array<Bool> {
		var a = new Array<Bool>();
		a.push( true );
		return a;
	}
	
}