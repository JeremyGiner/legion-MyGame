package mygame.game.misc.weapon;

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

	override function target_check( oWeapon :Weapon, oTarget :Unit ) :Bool {
		
		// Not null
		if( oTarget == null ) return false;
		
		// Not self
		if( oTarget == oWeapon.unit_get() ) return false;
		
		// Not dead
		if( oTarget.game_get() == null ) return false;
		
		// Check if owned by opponent
		//trace( ' '+_oUnit.owner_get().alliance_get( oTarget.owner_get() ) );
		if( oWeapon.unit_get().owner_get().alliance_get( oTarget.owner_get() ) == 'ally' )
			return false;
		
		//Health related
		var oHealth = oTarget.ability_get( Health );
			// Check if have Health ability
			if ( oHealth == null ) return false;
			
			// Cannot target unit WITH armor
			if( oHealth.armored_check() ) return false;
		
		// Check if in range
		if( !_inRange_check( oWeapon, oTarget ) ) return false;
		
		return true;
	}
	
}