package mygame.game.action;

import legion.entity.Player;
import legion.PlayerInput;
import mygame.game.ability.Platoon;
import mygame.game.entity.PlatoonUnit;
import mygame.game.entity.SubUnit;
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
		var oPlatoon = _oUnit.ability_get(Platoon);
		if ( oPlatoon != null ) {
			_oUnit.ability_get(Platoon).goal_set( _oDestination );
			return;
		}
		
		_oUnit.ability_get(Guidance).goal_set( _oDestination );
		
	}
	
	public function check( oGame :MyGame ) :Bool {
		if ( 
			_oUnit.ability_get(Guidance) == null && 
			_oUnit.ability_get(Platoon) == null 
		) return false;
		if( Std.is( _oUnit, SubUnit) ) return false; //TODO use ability to tellthem appart instead
		//return super.check( oPlayer );
		return true;
	}
	
}