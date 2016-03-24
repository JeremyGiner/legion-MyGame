package mygame.game.action;

import mygame.game.entity.Unit;
import legion.entity.Player;
import legion.PlayerInput;

import mygame.game.ability.BuilderFactory;

import space.Vector3 in Vector2;

class UnitOrderBuy implements IAction {

	var _iOfferIndex :Int;
	var _oUnit :Unit;
	
//______________________________________________________________________________
// Constructor

	public function new( 
		oUnit :Unit,
		iOfferIndex :Int
	) {
		_oUnit = oUnit;
		_iOfferIndex = iOfferIndex;
	}
	
//______________________________________________________________________________
// Accessor

	public function unit_get() { return _oUnit; }
	public function offerIndex_get() { return _iOfferIndex; }
	
//______________________________________________________________________________
// Utils
	
	public function exec( oGame :MyGame ) {
		if( !check( oGame ) ) throw('invalid input');
		//var oUnit = oGame.hero_get( _oPlayer );
		//TODO : check if unit has guidance
		_oUnit.ability_get(BuilderFactory).buy( _iOfferIndex );
	}
	
	public function check( oGame :MyGame ) :Bool {
		if( _oUnit.ability_get(BuilderFactory) == null ) return false;
		//return super.check( oPlayer );
		return true;
	}
	
}