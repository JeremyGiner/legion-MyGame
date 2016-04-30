package logicweaver_gigablaster.motor;

import logicweaver.entity.motor.IMotor;

/**
 * 
 * @author GINER Jérémy
 */
class EndTurn implements IMotor<Bool> {
	
	var _i :Float;
//_____________________________________________________________________________
// Constructor

	public function new( ) {
		_i = null;
	}
	
//_____________________________________________________________________________
// Accessor
	
	public function resolution_get() {
		return 1;
	}
	
	public function translate( aOutNode :Array<Float> ) {
		
		var v = aOutNode[0];
		if ( _i != v ) {
			_i = v;
			return true;
		}
		return false;
		//return v == null ? false : ( v > 0 );
	}
	
}