package mygame.game.action;

import legion.entity.Player;
import legion.PlayerInput;
import mygame.game.entity.PlatoonUnit;
import space.Vector2i;

import mygame.game.entity.Unit;

import mygame.game.ability.Guidance;

import space.Vector3 in Vector2;

class UnitOrderMove implements IAction {

	var _oDestination :Vector2i;
	var _oUnit :Unit;
	
//______________________________________________________________________________
// Constructor

	public function new( 
		oUnit :Unit,
		oDestination :Vector2i
	) {
		_oUnit = oUnit;
		_oDestination = oDestination;
	}
	
//______________________________________________________________________________
// Accessor

	public function unit_get() { return _oUnit; }
	public function direction_get() { return _oDestination; }
	
//______________________________________________________________________________
// Utils
	
	public function exec( oGame :MyGame ) {
		if( !check( oGame ) ) throw('invalid input');
		//var oUnit = oGame.hero_get( _oPlayer );
		//TODO : check if unit has guidance
		_oUnit.ability_get(Guidance).goal_set( _oDestination );
		
		if ( Std.is( _oUnit, PlatoonUnit ) ) {
			
		}
	}
	
	public function check( oGame :MyGame ) :Bool {
		if( _oUnit.ability_get(Guidance) == null ) return false;
		//return super.check( oPlayer );
		return true;
	}
	
}