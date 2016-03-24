package mygame.spirit.motor;

import mygame.game.action.UnitOrderMove;
import mygame.game.MyGame in Game;
import legion.entity.Entity;
import mygame.spirit.genic.OutNode;
import mygame.spirit.motor.Motor;
import mygame.spirit.sensor.Sensor;
import space.Vector2i;
import space.Vector3;
import trigger.IEventDispatcher;
import trigger.ITrigger;

/**
 * 
 * @author GINER Jérémy
 */
class UnitMove extends Motor<UnitOrderMove> implements ITrigger {

	var _oGame :Game;
	
//_____________________________________________________________________________
// Constructor

	public function new( oGame :Game ) {
		super( null );
		_aOutNode = new Array<OutNode>();
		for ( i in 0...3 )
			_aOutNode.push( new OutNode() );
		_aOutNode[2].onUpdate.attach( this );
		
		_bEnabled = false;
	}
	
//_____________________________________________________________________________
// Accessor
	
	public function action_get( lValue :Array<Float> ) {
		
		// Check if ready
		if ( !_bEnabled )
			return null;
		
		// Check length of lValue
		if ( lValue.length != 2 )
			trace('[ERROR]:Motor:action_get:invalide lValue length');
		
		// Convert lValue into a game input
		return new UnitOrderMove(
				_oGame,
				new Vector2i( Math.round( lValue[0]*10000 ), Math.round( lValue[1]*10000 ) )
			);
	}
	
	
	override public function out_get() {
		return new UnitOrderMove( 
			_oGame.entity_get( Math.round( _aOutNode[0].value_get() ) ), 
			new Vector2i( _aOutNode[0].value_get(), _aOutNode[1].value_get() ) 
		);
	}
	
//_____________________________________________________________________________
// Trigger

	public function trigger( oSrouce :IEventDispatcher ) {
		out_get();
		// TODO: put into a game
	}
	
}