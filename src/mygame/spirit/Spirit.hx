package mygame.spirit;
import mygame.spirit.genic.NodeNetwork;
import mygame.spirit.sensor.ISensor;
import mygame.spirit.motor.IMotor;

typedef Motor = IMotor<Dynamic>;

/**
 * Associate sensors, motors and a NodeNet
 * 
 * @author GINER Jérémy
 */

class Spirit {

	var _aSensor :Array<ISensor>;
	var _aMotor :Array<Motor>;
	
	var _oNodeNet :NodeNetwork;
	
	var sIdentity :String;	// Algorithm.Seed.Generation.Identity
	
//_____________________________________________________________________________
// Constructor

	function new( oNodeNet :NodeNetwork, aSensor :Array<ISensor>, aMotor :Array<Motor> ) {
		_aSensor = aSensor;
		_aMotor = aMotor;
		
		var iInRes :Int = 0;	//Input Resolution
		for ( o in _aSensor )
			iInRes += o.resolution_get();
		
		var iOutRes :Int = 0;	//Output Resolution
		for ( o in _aMotor )
			iOutRes += o.resolution_get();
		
		_oNodeNet = new NodeNetwork( iInRes, iOutRes, 100 );
	}
	/*
	function _sensor_init() {
		
	}*/
	
//_____________________________________________________________________________
// Accessor

	public function sensor_get_all() {
		return _aSensor;
	}
	
	public function motor_get_all() {
		return _aMotor;
	}
	
	public function nodenet_get() { return _oNodeNet; }
//_____________________________________________________________________________
// Modifier


//_____________________________________________________________________________
// Sub routine

	/**
	 * Generate a default nodenet
	 */
	function _nodenet_init() {
		
	}
//_____________________________________________________________________________
// Disposer

	public function dipose() {
		// Not necessary for this object
	}
	
}