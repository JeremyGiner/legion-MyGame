package mygame.spirit.sensor;

typedef Float as Num;

/**
 * ...
 * @author GINER Jérémy
 */
class Composite implements ISensor {

	var _aSensor :Array<ISensor>;
	var _aValue :Array<Num>;
	
//_____________________________________________________________________________
//	Constructor
	
	public function new( aSensor :Array<ISensor> ) {
		_aSensor = aSensor;
	}
	
//_____________________________________________________________________________
//	Accesor

	public function resolution_get() { return 0; }
	public function value_get() :Array<Float> {
		var a = new Array<Float>();
		a.add( 1 );
		return a;
	}
	public function mask_get() :Array<Bool> {
		var a = new Array<Bool>();
		a.add( true );
		return a;
	}
//_____________________________________________________________________________
//	Updater

	public function update() {
		for()
	}
	
}