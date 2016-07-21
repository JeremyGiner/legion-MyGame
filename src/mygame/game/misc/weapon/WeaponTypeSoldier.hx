package mygame.game.misc.weapon;

import legion.entity.Entity;
import mygame.game.ability.Weapon;
import mygame.game.ability.Health;
import mygame.game.entity.Unit;

import mygame.game.misc.weapon.EDamageType;

/**
 * Class defining most of the behavior of the weapon Ability for Soldier unit.
 * 
 * @author GINER Jérémy
 */
class WeaponTypeSoldier extends WeaponType {

//______________________________________________________________________________
//	Constructor

	public function new() {
		super( 
			Bullet,	//Damage type
			5,	// power
			10,	// speed (loop)
			5000	//range
		);
	}
	
//______________________________________________________________________________
//	Utils

	override function target_check( oWeapon :Weapon, oTarget :Entity ) :Bool {
		if ( super.target_check( oWeapon, oTarget ) == false )
			return false;
		
		//Health related
		var oHealth = oTarget.ability_get( Health );
			// Check if have Health ability
			if ( oHealth == null ) return false;
			
			// Cannot target unit WITH armor
			if( oHealth.armored_check() ) return false;
		
		return true;
	}
	
}