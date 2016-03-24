package mygame.spirit.motor;

import mygame.game.action.UnitOrderMove;
import mygame.game.MyGame in Game;
import legion.entity.Entity;
import mygame.spirit.genic.OutNode;
import mygame.spirit.motor.Motor;
import mygame.spirit.sensor.Eyeball;
import mygame.spirit.sensor.Sensor;
import space.Vector2i;
import space.Vector3;
import trigger.IEventDispatcher;
import trigger.ITrigger;

/**
 * 
 * @author GINER Jérémy
 */
class MotorEyeball extends Motor<Eyeball> {

	var _oEye :Eyeball;
	
//_____________________________________________________________________________
// Constructor

	public function new( aOutNode :Array<OutNode>, oEye :Eyeball ) {
		super( aOutNode );
		
		_oEye = oEye;
	}
	
//_____________________________________________________________________________
// Accessor
	
	override public function resolution_get() {
		return 1;
	}
	
	override public function out_get() {
		// update eye
		var v :Int = Math.round( _aOutNode[0].value_get() );
		
		// Case Next
		if ( v == -1 ) {
			var a = _oEye.
		}
			
		//___
		return _oEye;
	}
	
}