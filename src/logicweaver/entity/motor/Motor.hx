package logicweaver.entity.motor;

import logicweaver.node.OutNode;

/**
 * Convert part of the game stat into a float array
 * 
 * @author GINER Jérémy
 */
class Motor<CType> implements IMotor<CType> {

	var _oCache :CType;
	
//_____________________________________________________________________________
//	Constructor
	
	function new() {
		_oCache = null;
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function resolution_get() { 
		throw('abstract method');
		return null;
	}
	
	public function update( aOutNode :Array<Float>) {
		throw('abstract method');
		return null;
	}
	
	public function out_get() :CType {
		return _oCache;
	}
}