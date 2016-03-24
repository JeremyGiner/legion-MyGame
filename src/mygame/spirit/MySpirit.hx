package mygame.spirit;

import mygame.game.entity.Player;
import mygame.game.entity.Unit;
import mygame.game.MyGame;
import mygame.spirit.genic.NodeNetwork;
import mygame.spirit.sensor.Boot;
import mygame.spirit.sensor.Eyeball;
import mygame.spirit.sensor.Sensor;
import mygame.spirit.motor.Motor;
import mygame.spirit.motor.UnitMove;

/**
 * 
 * 
 * @author GINER Jérémy
 */

class MySpirit extends Spirit {
	
	var _oEnvironement :MyGame;
	var _oPlayer :Player;
	
//_____________________________________________________________________________
// Constructor

	public function new( oNodeNet :NodeNetwork, oEnvironement :MyGame, oPlayer :Player ) {
		_oEnvironement = oEnvironement;
		_oPlayer = oPlayer;
		
		super(
			[
				new Boot(),
				new Eyeball( cast _oEnvironement.entity_get( 0 ) )
			],
			[
				new UnitMove( _oEnvironement )
			]
		);
		
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

	public function player_get() {
		return _oPlayer;
	}
	
//_____________________________________________________________________________
// Process

	

//_____________________________________________________________________________
// Disposer

	override public function dipose() {
		// Not necessary for this object
	}
	
}