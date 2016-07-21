package mygame.game.misc.weapon;

import mygame.game.entity.Unit;

/**
 * Class defining most of the behavior of the weapon Ability for Bazoo unit
 * 
 * @author GINER Jérémy
 */
class WeaponTypeTank extends WeaponType {

//______________________________________________________________________________
//	Constructor

	public function new() {
		super( 
			EDamageType.Shell,
			100,
			30,
			10000
		);
	}
	
}