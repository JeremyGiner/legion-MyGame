package mygame.game.action;

import legion.entity.Player;
import space.Vector2i;

import mygame.game.ability.Mobility;
import mygame.game.ability.Guidance;

class UnitDirectControl implements IAction {

	var _oDirection :Vector2i;
	var _oPlayer :Player;
	
//______________________________________________________________________________
// Constructor

	public function new( 
		oPlayer :Player,
		oDirection :Vector2i
	) {
		_oPlayer = oPlayer;
		_oDirection = oDirection;
	}
	
//______________________________________________________________________________
// Accessor

	public function direction_get() { return _oDirection; }
	
//______________________________________________________________________________
// Utils
	
	public function exec( oGame :MyGame ) {
		
		var oUnit = oGame.hero_get( cast _oPlayer );	//TODO : create shortcut
		oUnit.ability_get( Mobility ).force_set(
			'Direct',
			_oDirection.x,
			_oDirection.y,
			true
		);
		//oUnit.ability_get( Guidance ).goal_set( _oDirection );
		oUnit.ability_remove( Guidance );
	}
	
	public function check( oGame :MyGame ) :Bool {

		//return super.check( oPlayer );
		return true;
	}
	
}