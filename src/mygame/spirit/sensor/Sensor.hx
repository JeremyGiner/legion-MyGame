package mygame.spirit.sensor;
import haxe.rtti.CType;

/**
 * Convert input type into Array<Float>
 * @author GINER Jérémy
 */
class Sensor<CType> implements ISensor {

	var _oReference :CType;
	var _aValue :Array<Float>;
	
//_____________________________________________________________________________
// Constructor
	
	function new() {
		
	}

//_____________________________________________________________________________
// Accessor

	
	
	public function resolution_get() { return 0; }
	public function value_get() :Array<Float> {
		throw('Abstract funciton');
		return new Array<Float>();
	}
	
//_____________________________________________________________________________
// Modifier

	public function reference_set( oReference :CType ) {
		_oReference = oReference;
	}
	
}