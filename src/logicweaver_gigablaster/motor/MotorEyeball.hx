package logicweaver_gigablaster.motor;

import logicweaver.entity.motor.IMotor;
import logicweaver_gigablaster.sensor.Eyeball;
import logicweaver.node.OutNode;

/**
 * 
 * @author GINER Jérémy
 */
class MotorEyeball implements IMotor<Eyeball> {

	var _oEye :Eyeball;
	
//_____________________________________________________________________________
// Constructor

	public function new( oEye :Eyeball ) {
		_oEye = oEye;
	}
	
//_____________________________________________________________________________
// Accessor
	
	public function resolution_get() {
		return 1;
	}
	
	public function translate( aOutNode :Array<Float> ) {
		
		// Case : no unit -> reset
		if ( _oEye.unit_get() == null ) {
			return _oEye.reset();
		}
		
		if ( aOutNode[0] == null ) 
			return _oEye;
		
		if ( aOutNode[0] < 0 ) {
			// Prev
			return _oEye.prev();
		} else {
			// Next
			return _oEye.next();
		}
		
		return _oEye;
	}
	
//_____________________________________________________________________________
//	Sub-routine

	
	
}