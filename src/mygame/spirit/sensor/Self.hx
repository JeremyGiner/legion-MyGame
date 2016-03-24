package mygame.spirit.sensor;
import mygame.game.entity.Bazoo;
import mygame.game.entity.City;
import mygame.game.entity.Factory;
import mygame.game.entity.Unit;
import mygame.game.MyGame in Game;
import legion.entity.Entity;
import mygame.spirit.sensor.Sensor;

/**
 * Convert part of the game stat into a float array
 * @author GINER Jérémy
 */
class Self extends Sensor<Dynamic> {

	var _oUnit :Unit;
	
	public function new( oUnit :Unit ) {
		_oUnit = oUnit;
		
	}
	
	public function process() {
		//TODO : get unit info
		
		// Get player id
		this._aValue_oUnit.owner_get().playerId_get();
		
		// get n of the units closest to _oUnit
			// get unit type id
			// get relative position x / y
	}
	
	public function _type_to_float( oUnit :Unit ) {
		switch( Type.getClass( oUnit ) ) {
			case Bazoo : return 1;
			case City : return 2;
			case Factory : return 3;
		}
		trace('ERROR:type_to_flaot:unimplemented type.');
		return null;
	}
}