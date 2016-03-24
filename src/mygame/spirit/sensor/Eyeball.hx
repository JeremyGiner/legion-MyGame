package mygame.spirit.sensor;
import mygame.game.entity.Bazoo;
import mygame.game.entity.City;
import mygame.game.entity.Factory;
import mygame.game.entity.Unit;
import mygame.game.MyGame;
import legion.entity.Entity;
import mygame.spirit.sensor.Sensor;

/**
 * Convert part of the game stat into a float array
 * @author GINER Jérémy
 */
class Eyeball extends Sensor<Unit> {

	var _oUnit :Unit;
	var _oEnv :MyGame;
	
	public function new( oEnv :MyGame ) {
		super();
		_oEnv = oEnv;
		oEnv.unitList_get().
		_oUnit = oUnit;
	}
	
	
	
	public function _type_to_float( oUnit :Unit ) {
		
		if ( oUnit == null )
			return -1;
		
		switch( Type.getClass( oUnit ) ) {
			case Bazoo : return 1;
			case City : return 2;
			case Factory : return 3;
		}
		trace('ERROR:type_to_flaot:unimplemented type.');
		return null;
	}
}