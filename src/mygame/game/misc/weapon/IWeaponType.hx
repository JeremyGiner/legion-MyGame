package mygame.game.misc.weapon;

import legion.entity.Entity;
import mygame.game.ability.Weapon;
import mygame.game.entity.Unit;
import mygame.game.utils.IValidatorEntity;

/**
 * Interface of a class defining most of the behavior of the weapon Ability
 * 
 * - speed : measurement unit in loop, must be strictly higher than 0
 * 
 * @author GINER Jérémy
 */
interface IWeaponType {
	
//______________________________________________________________________________
//	Accessor
	
	public function damageType_get() :EDamageType;
	public function power_get() :Float;
	public function rangeMax_get() :Float;
	public function speed_get() :Int;	// Must be strictly higher than 0
	
//______________________________________________________________________________
//	Utils

	public function target_check( oWeapon :Weapon, oTarget :Entity ) :Bool;
}