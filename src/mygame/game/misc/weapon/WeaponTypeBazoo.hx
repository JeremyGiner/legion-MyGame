package mygame.game.misc.weapon;

import mygame.game.entity.Unit;

/**
 * Class defining most of the behavior of the weapon Ability for Bazoo unit
 * 
 * @author GINER Jérémy
 */
class WeaponTypeBazoo extends WeaponType {

//______________________________________________________________________________
//	Constructor

	public function new() {
		super( 
			EDamageType.Shell,
			50,
			20,
			10000
		);
	}
	
}