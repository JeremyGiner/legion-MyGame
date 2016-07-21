package mygame.game.misc.weapon;

import legion.entity.Entity;
import mygame.game.ability.Loyalty;
import mygame.game.query.EntityDistance;
import mygame.game.query.EntityDistance;
import mygame.game.utils.IValidatorEntity;
import space.Vector2i in Point;
import mygame.game.ability.Weapon;
import mygame.game.ability.Health;
import mygame.game.ability.Position;
import mygame.game.entity.Unit;

/**
 * Default class defining most of the behavior of the weapon Ability
 * 
 * @author GINER Jérémy
 */
class WeaponType implements IWeaponType {

	var _eType :EDamageType;
	var _fPower :Float;
	var _fRangeMax :Float;
	var _fSpeed :Int;
	
	// TODO : target container type : allowing multi-target

//______________________________________________________________________________
//	Constructor

	public function new(
		eType :EDamageType,
		fPower :Float,
		fSpeed :Int,
		fRangeMax :Float
	) {
		_eType = eType;
		_fPower = fPower;
		_fRangeMax = fRangeMax;
		_fSpeed = Math.round( Math.max( 1, fSpeed ) );//TODO: use max function for Int
		
	}

//______________________________________________________________________________
//	Accessor
	
	public function damageType_get() { return _eType; }
	public function power_get() { return _fPower; }
	public function rangeMax_get() { return _fRangeMax; }
	public function speed_get() { return _fSpeed; }
	
//______________________________________________________________________________
//	Utils

	public function target_check( oWeapon :Weapon, oTarget :Entity ) :Bool {
		
		
		// Not null
		if( oTarget == null ) return false;
		
		// Not self
		if( oTarget == oWeapon.unit_get() ) return false;
		
		// Not dead
		if ( oTarget.game_get() == null ) return false;
		
		// Check loyalty
		var oWeaponLoyalty :Loyalty = cast oWeapon.unit_get().abilityMap_get().get('mygame.game.ability.Loyalty');
		if ( oWeaponLoyalty == null ) return false;
		
		var oTargetLoyalty :Loyalty = cast oTarget.abilityMap_get().get('mygame.game.ability.Loyalty');
		if ( oTargetLoyalty == null ) return false;
		
		
		// Check if owned by opponent
		//trace( ' '+_oUnit.owner_get().alliance_get( oTarget.owner_get() ) );
		if ( oWeaponLoyalty.owner_get().alliance_get( oTargetLoyalty.owner_get() ) == ally )
			return false;
		
		// Check if have Health ability
		if ( oTarget.ability_get( Health ) == null ) return false;
		
		// Check if in range
		if( !_inRange_check( oWeapon, cast oTarget ) ) return false;
		
		
		//TODO : check if land
		
		//TODO : check if ...
		
		return true;
	}
//______________________________________________________________________________
//	Sub-routine

	function _inRange_check( oWeapon :Weapon, oUnit :Unit ) :Bool {
		return ( 
			oUnit.game_get().singleton_get(EntityDistance)
				.distanceSqed_get(oWeapon.unit_get(), oUnit).get() <= _fRangeMax*_fRangeMax
		);
	}
}