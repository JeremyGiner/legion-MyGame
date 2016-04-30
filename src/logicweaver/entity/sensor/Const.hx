package logicweaver.entity.sensor;

/**
 * Convert part of the game stat into a float array
 * @author GINER Jérémy
 */
class Const implements ISensor {

	var _aValue :Array<Float>;
	
//_____________________________________________________________________________
//	Constructor

	public function new( aValue :Array<Float> ) {
		_aValue = aValue;
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function resolution_get() {
		return _aValue.length;
	}
	
	public function value_get() :Array<Float> {
		return _aValue;
	}
	
	public function update_check() {
		return false;
	}
	
//_____________________________________________________________________________
//	Modifier
	
	public function set( aValue :Array<Float> ) {
		return this;
	}
}