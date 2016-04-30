package mygame.game.process;

import legion.entity.Entity;
import mygame.game.MyGame;
import mygame.game.ability.Weapon;
import mygame.game.entity.Unit;
import mygame.game.query.EntityQuery;

import trigger.*;

class WeaponProcess implements ITrigger {

	var _oGame :MyGame;
	
	var _oQueryWeapon :EntityQuery;

//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame ) {
		_oGame = oGame;
		_oQueryWeapon = new EntityQuery( _oGame, [ 'ability' => Weapon ] );
		
		_oGame.onLoop.attach( this );
	}
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		// on loop
		if ( oSource == _oGame.onLoop ) {
			var aEntity = _oQueryWeapon.data_get(null);
			
			// Targeting
			for ( oEntity in aEntity ) {
				oEntity.ability_get(Weapon).swipe_target();
			}
			
			// Firing
			for ( oEntity in aEntity ) {
				oEntity.ability_get(Weapon).fire();
			}
		}
		
	
	}
}