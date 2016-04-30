package logicweaver.entity;

import logicweaver.node.ILogic;
import logicweaver.entity.motor.IMotor;
import logicweaver.entity.sensor.ISensor;

typedef Motor = IMotor<Dynamic>;

/**
 * Associate sensors, motors and a NodeNet
 * Basicly an interface between the NodeNet and the environement
 * 
 * @author GINER Jérémy
 */
class Entity {

	var _aSensor :Array<ISensor>;
	var _aMotor :Array<Motor>;
	
	var _oLogic :ILogic;
	
	var _sOrigin :String; // Algorithm.Seed.Generation.ParentIdentity
	var _iIdentity :Int;	
	
//_____________________________________________________________________________
// Constructor

	function new( 
		iIdentity :Int, 
		sOrigin :String,
		oNodeNet :ILogic, 
		aSensor :Array<ISensor>, 
		aMotor :Array<Motor> 
	) {
		_iIdentity = iIdentity;
		_sOrigin = sOrigin;
		
		_aSensor = aSensor;
		_aMotor = aMotor;
		
		_oLogic = oNodeNet;
		
		//Check nodenet
		if ( oNodeNet.outResolution_get() != outResolution_get() ) 
			throw('Invalid out res');
		if ( oNodeNet.inResolution_get() != inResolution_get() ) 
			throw('Invalid in res');
		
	}
	/*
	function _sensor_init() {
		
	}*/
	
//_____________________________________________________________________________
// Accessor

	public function id_get() {
		return _iIdentity;
	}
	
	public function origin_get() {
		return _sOrigin;
	}

	public function sensor_get_all() {
		return _aSensor;
	}
	
	public function motor_get_all() {
		return _aMotor;
	}
	
	public function nodenet_get() { 
		return _oLogic; 
	}
	
	public function inResolution_get() {
		var i :Int = 0;	//Input Resolution
		for ( o in _aSensor )
			i += o.resolution_get();
		return i;
	}
	public function outResolution_get() {
		var i :Int = 0;	//Input Resolution
		for ( o in _aMotor )
			i += o.resolution_get();
		return i;
	}
	
//_____________________________________________________________________________
// Modifier

//_____________________________________________________________________________
// Process
	
	/**
	 * -update inNode
	 * -process NodeNet ( ~1 instruction )
	 * -process Motor
	 */
	public function process() {
		
		
		// Update nodenet input
			// Translate env into input via sensor
			var a :Array<Float> = [];
			var bUpdateNeeded :Bool = false;
			for ( oSensor in _aSensor ) {
				bUpdateNeeded = bUpdateNeeded || oSensor.update_check();
				a = a.concat( oSensor.value_get() );
			}
			
			// Update nodenet input
			_oLogic.input_set( a );
		
		// Process nodenet
		_oLogic.process();
		
		// Process out (necessary for motor with feedback loop)
		var i = 0;	// InNode offset
		var aOutNode = _oLogic.out_get();
		var a :Array<Dynamic> = [];
		for ( oMotor in _aMotor ) {
			a.push( oMotor.translate( aOutNode.slice( i, i + oMotor.resolution_get() + 1 ) ) );
			i += oMotor.resolution_get();
		}
		
		return a;
	}


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