package mygame.game.ability;
import legion.ability.Ability;
import legion.entity.Entity;
import mygame.game.entity.AirStrike;

/**
 * Allow unit to follow air strike
 * @author GINER Jérémy
 */
class AirStriker extends Ability {

	var _oEntity :Entity;
	var _oAirStrike :AirStrike;
	
//______________________________________________________________________________
//	Constructor
	
	public function new( oEntity :Entity ) {
		_oEntity = oEntity;
		_oAirStrike = null;
		
		//DEV : assert no position
		if ( _oEntity.ability_get(Position) != null ) throw('require no position');
	}
	
//______________________________________________________________________________
//	Accessor

	public function airStrike_get() {
		return _oAirStrike;
	}

//______________________________________________________________________________
//	Modifier

	public function airStrike_set( oAirStrike :AirStrike ) {
		if ( _oAirStrike == null )
			throw('error');
		
		_oAirStrike = oAirStrike;
	}
}