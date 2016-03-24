package mygame.spirit;
import mygame.spirit.neural.NeuNet;
import mygame.spirit.sensor.Eyeball;

/**
 * An IA using a neural network variant
 * @author GINER Jérémy
 */

class SpiritNeural extends Spirit {

	var _oNeunet :NeuNet;
	
//_____________________________________________________________________________
// Constructor

	override public function new() {
		super();
		
		_aSensor.push( new Eyeball() );
	}
	
//_____________________________________________________________________________
// 

	override public function output_get() {
		
	}
	
	public function process() {
		// Process sensor
		for( oSensor in _aSensor )
			oSensor
		
		// inject sensor's result into neunet
		
		// Process neunet
	}
}