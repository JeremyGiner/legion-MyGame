package mygame.spirit;
import math.Random;
import mygame.spirit.genic.NodeNetwork;
import mygame.spirit.sensor.Sensor;

/**
 * Change node quantity and link at pseudo-random.
 * @author GINER Jérémy
 */

class Mutator<CNodeNet:NodeNetwork> {

	var _oRandom :Random;
	
//_____________________________________________________________________________
// Constructor

	function new() {
		_oRandom = new Random();
	}
	
//_____________________________________________________________________________
// 

	public function mutate( oNodeNet :CNodeNet ) {
		throw('Not implemeented yet');
		//TODO
		
		// Remove 0 to 3 node

		
		// Change 0 to 3 connection
		
		
		// Add 0 to 3 node
		
		return new NodeNetwork( 0,0,0);
	}
	
	
}