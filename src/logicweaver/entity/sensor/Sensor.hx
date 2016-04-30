package logicweaver.entity.sensor;

import logicweaver.node.NodeNetwork;
import logicweaver.node.OutNode;

/**
 * Convert part of the game stat into a float array
 * 
 * @author GINER Jérémy
 */
class Sensor implements ISensor {

	var _oNodeNet :NodeNetwork;
	
//_____________________________________________________________________________
//	Constructor
	
	function new( oNodeNet :NodeNetwork ) {
		_oNodeNet = oNodeNet;
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function resolution_get() {
		throw('abstract method');
		return null;
	}
	
	public function value_get() {
		
	}
	
}