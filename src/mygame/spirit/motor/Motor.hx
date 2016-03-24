package mygame.spirit.motor;

import mygame.game.MyGame in Game;
import legion.entity.Entity;
import mygame.spirit.sensor.Sensor;
import mygame.spirit.genic.OutNode;

/**
 * Convert part of the game stat into a float array
 * 
 * @author GINER Jérémy
 */
class Motor<CType> implements IMotor<CType> {

	var _aOutNode :Array<OutNode>;
	
//_____________________________________________________________________________
//	Constructor
	
	function new( aOutNode :Array<OutNode> ) {
		_aOutNode = aOutNode;
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function outNodeArray_get() {
		return _aOutNode;
	}
	
	public function resolution_get() { return _aOutNode.length; }
	
	public function out_get() :CType {
		throw('abstract method');
		return null;
	}
}