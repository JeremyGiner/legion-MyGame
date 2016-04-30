package logicweaver_gigablaster.sensor;

import logicweaver.entity.sensor.ISensor;

/**
 * Convert part of the game stat into a float array
 * @author GINER Jérémy
 */
class Context implements ISensor {
	
	var _oEntity :GigaEntity;
	
//_____________________________________________________________________________
//	Constructor

	public function new( oEntity :GigaEntity ) {
		_oEntity = oEntity;
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function resolution_get() {
		return 1;// player id
	}
	
	public function value_get() :Array<Float> {
		return [ _oEntity.playerId_get() ];
	}
	
	public function update_check() {
		return false;
	}
}