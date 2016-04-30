package mygame.game.ability;

import legion.ability.IAbility;
import mygame.game.entity.Unit;
import mygame.game.ability.Position;
import mygame.game.ability.Health;
import mygame.game.misc.weapon.EDamageType;
import mygame.game.misc.weapon.IWeaponType;
import mygame.game.process.WeaponProcess;
import trigger.EventDispatcher2;
import trigger.IEventDispatcher;
import trigger.ITrigger;

import mygame.game.utils.Timer;

/**
 * Ability allowing to damage other unit
 * - process : targeting then firing
 * @author GINER Jérémy
 */
class Weapon extends UnitAbility {

	var _oType :IWeaponType;
	var _oTarget :Unit = null;
	var _oCooldown :Timer;

//____

	public var onFire :EventDispatcher2<Weapon>;

//______________________________________________________________________________
//	Constructor

	public function new( oOwner :Unit, oType :IWeaponType ) {
		super( oOwner );
		
		_oType = oType;
		_oCooldown = new Timer( cast _oUnit.game_get(), _oType.speed_get(), false );
		_oCooldown.reset();
		
		onFire = new EventDispatcher2<Weapon>();
	}
	
//______________________________________________________________________________
//	Accessor

	public function rangeMax_get() {
		return _oType.rangeMax_get();
	}

	
	public function cooldown_get() { return _oCooldown; }
	
	public function target_get() :Unit {
		_target_update();
		return _oTarget;
	}
	
//______________________________________________________________________________
//	Modifier

	public function target_suggest( oTarget :Unit ) :Bool {
		
		// Pass if already got a target, or suggested target is invalid
		if( _oTarget != null || !target_check( oTarget ) ) 
			return false;
		
		_oTarget = oTarget;
		return true;
	}

//______________________________________________________________________________
//	Sub-routine
	
	function _fire() {
		
		//Trigger
		onFire.dispatch( this );
		
		// Set cooldown
		_oCooldown.reset();
		
		// Apply hit
		var oHealth = _oTarget.ability_get( Health );
		oHealth.damage( _oType.power_get(), _oType.damageType_get() );
	}
	
	function _target_update() {
		// Reset target if no longer valid
		if( !target_check( _oTarget ) ) 
			_oTarget = null;
	}
	
	function target_check( oTarget :Unit ) :Bool {
		return _oType.target_check( this, oTarget );
	}
	
	
//______________________________________________________________________________
//	Process

	//TODO : Replace by collision layer
	public function swipe_target() {
		
		// Update current target
		_target_update();
		
		// Check if new target needed
		if ( _oTarget != null )
			return;
		
		// Look for better target
		for ( oTarget in _oUnit.mygame_get().entity_get_all() ) 
			if( Std.is( oTarget, Unit ) )
				target_suggest( cast oTarget );
	}
	
	public function fire() {
		// Fire on cooldown expire
		if( _oCooldown.expired_check() && _oTarget != null ) {
			_fire();
		}
	}
}