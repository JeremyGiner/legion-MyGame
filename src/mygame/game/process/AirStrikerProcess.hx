package mygame.game.process;
import mygame.game.ability.AirStriker;
import mygame.game.MyGame;
import mygame.game.query.EntityQuery;

/**
 * State 0 : no position no air strike
 * State 1 : air strike assigned -> waiting for more air striker to join
 * State 2 : AirStrike time expired -> create position for each air striker
 * State 3 : -> update position ( depending on percent ) (process optional drop)
 * State 4 : reach end of track -> remove position
 * 
 * @author GINER Jérémy
 */
class AirStrikerProcess {

	var _oGame :MyGame;
	var _oQueryAirStriker :EntityQuery;
	
	public function new( oGame :MyGame ) {
		_oGame = oGame;
		_oQueryAirStriker = new EntityQuery( _oGame, [ 'ability' => AirStriker ] );
	}
	
	
	public function process() {
		for ( oEntity in _oQueryAirStriker.data_get(null) ) {
			// Init air strike
		}
	}
}