package mygame.game.action;

import legion.entity.Player;
import legion.PlayerInput;
import mygame.game.ability.Platoon;
import mygame.game.entity.SubUnit;
import space.Vector2i;

import mygame.game.entity.Unit;

import mygame.game.ability.Guidance;

import space.Vector3 in Vector2;

class UnitOrderMove implements IAction {

	var _oDestination :Vector2i;
	var _fAngle :Float;
	var _oUnit :Unit;
	var _bStack :Bool;
	
//______________________________________________________________________________
// Constructor

	public function new( 
		oUnit :Unit,
		oDestination :Vector2i,
		fAngle :Float,
		bStack :Bool = false
	) {
		_oUnit = oUnit;
		_fAngle = fAngle;
		_oDestination = oDestination;
		_bStack = bStack;
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
		
		// Case: platoon
		var oPlatoon = _oUnit.ability_get(Platoon);
		if ( oPlatoon != null ) {
			if( _bStack )
				_oUnit.ability_get(Platoon).waypoint_add( _oDestination, _fAngle );
			else
				_oUnit.ability_get(Platoon).waypoint_set( _oDestination, _fAngle );
			return;
		}
		
		// Guidance
		if( _bStack )
			_oUnit.ability_get(Guidance).waypoint_add( _oDestination );
		else
			_oUnit.ability_get(Guidance).waypoint_set( _oDestination );
		
	}
	
	public function check( oGame :MyGame ) :Bool {
		// Require guidance or platoon
		if ( 
			_oUnit.ability_get(Guidance) == null && 
			_oUnit.ability_get(Platoon) == null 
		) return false;
		//return super.check( oPlayer );
		return true;
	}
	
}