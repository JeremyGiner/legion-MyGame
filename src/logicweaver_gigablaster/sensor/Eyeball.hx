package logicweaver_gigablaster.sensor;

import logicweaver.entity.sensor.ISensor;
import logicweaver_gigablaster.GigaEntity;

/**
 * Convert part of the game stat into a float array
 * @author GINER Jérémy
 */
class Eyeball implements ISensor {

	var _oEntity :GigaEntity;
	var _iUnitId :Int;
	
	var _bUpdateCheck :Bool;
	
//_____________________________________________________________________________
//	Constructor

	public function new( oEntity :GigaEntity ) {
		
		_oEntity = oEntity;
		_iUnitId = 0;
		_bUpdateCheck = false;
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function resolution_get() {
		return 6;// id, owner id, type, posx, posy, deployed
	}
	
	public function unit_get() {
		return _oEntity.game_get().getUnit( _iUnitId );
	}
	
	public function value_get() :Array<Float> {
		var oUnit = unit_get();
		
		if ( oUnit == null )
			return [ null, null, null, null, null, null ];
		
		return [
			oUnit.id_get(),
			oUnit.getPlayer().id_get(),
			_type_to_float( oUnit ),
			oUnit.getPosX(),
			oUnit.getPosY(),
			0	//TODO : deployed
		];
	}
	
	public function unitId_get() {
		return _iUnitId;
	}
	
	public function update_check() {
		if ( _bUpdateCheck == true ) {
			_bUpdateCheck = false;
			return true;
		}
		return false;
	}
	
//_____________________________________________________________________________
//	Modifier
	
	public function unitId_set( i :Int ) {
		_iUnitId = i;
		_bUpdateCheck = true;
		return this;
	}
	
	public function reset() {
		// Assume parent is in a context
		
		//
		var aUnit :Array<Dynamic> = php.Lib.toHaxeArray( untyped _oEntity.game_get().getUnitList() );
		
		// set eye on first unit
		unitId_set( aUnit.pop().getId() );
		
		return this;
	}
	
	public function prev() {
		// Assume parent is in a context
		
		// 
		if ( _iUnitId == -1 ) {
			reset();
			return this;
		}
		
		var aUnit = php.Lib.hashOfAssociativeArray( untyped _oEntity.game_get().getUnitList() );
		//untyped __call__('var_dump', untyped _oEntity.game_get().getUnitList() );
		//untyped __call__('var_dump', aUnit );
		
		var oPrev = null;
		var oTarget = null;
		for ( oUnit in aUnit ) {
			if ( oUnit.getId() == unitId_get() ) {
				oTarget = oPrev;
			}
			oPrev = oUnit;
		}
		
		if ( oTarget != null )
			unitId_set( oTarget.getId() );	// 
		else
			unitId_set( oPrev.getId() );	// Last of the list
		
		return this;
	}
	
	public function next() {
		var aUnit = php.Lib.hashOfAssociativeArray( untyped _oEntity.game_get().getUnitList() );
		
		var oPrev = null;
		for ( oUnit in aUnit ) {
			if (
				oPrev != null &&
				oPrev.getId() == unitId_get() 
			) {
				unitId_set( oUnit.getId() );
				return this;
			}
			oPrev = oUnit;
		}
		
		// Case : current unit is last element -> his next will be the first element
		return reset();
	}
	
//_____________________________________________________________________________
//	Sub-routine
	
	public function _type_to_float( oUnit :Dynamic ) {
		
		if ( oUnit == null )
			return null;
		
		switch( oUnit.getTypeName() ) {
			case 'footman' : return 1;
			case 'archer' : return 1;
			case 'catapult' : return 2;
			case 'spearman' : return 2;
			case 'knight' : return 3;
		}
		trace('ERROR:type_to_flaot:unimplemented type.');
		return null;
	}
}