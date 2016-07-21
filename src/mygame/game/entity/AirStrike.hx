package mygame.game.entity;

import legion.entity.Entity;
import mygame.game.ability.AirStriker;
import mygame.game.utils.Timer;
import space.Vector2i;

import mygame.game.MyGame in Game;

/**
 * An air strike
 * @author GINER Jérémy
 */
class AirStrike extends Entity {

	var _oPosition :Vector2i;
	var _aAirStriker :Array<Entity>;
	
	/**
	 * Time the interval of time durong which more air striker can be added
	 */
	var _oTimer :Timer;

//______________________________________________________________________________
//	Constructor

	public function new( oGame :Game, oAirStriker :Entity, oPosition :Vector2i ) {
		super( oGame );
		
		// DEV : assert entity have ir strike
		if ( oAirStriker.ability_get(AirStriker) == null ) throw('NOt an airstriker');
		
		_oPosition = oPosition;
		_aAirStriker = [ oAirStriker ];
		_oTimer = new Timer( _oGame, 100 );
		
	}
	
//______________________________________________________________________________
//	Accessor

	public function striker_add( oAirStriker :Entity ) {
		
		// Check timer
		if ( _oTimer.expired_check() )
			return;
		
		// Check striker
		// TODO : check striker owner opponent
		// TODO : check not already assign
		
		// Apply change
		_aAirStriker.push( oAirStriker );
		oAirStriker.ability_get(AirStriker).airStrike_set( this );
	}
	
	public function process() {
		if ( !_oTimer.expired_check() )
			return;
		
		
	}
}
