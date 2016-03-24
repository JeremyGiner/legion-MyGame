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
class Weapon extends UnitAbility implements ITrigger {

	var _oType :IWeaponType;
	var _oTarget :Unit = null;
	var _oCooldown :Timer;

//____
	
	var _oProcess :WeaponProcess;
	
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
		
		// Trigger
		_oProcess = _oUnit.mygame_get().oWeaponProcess;
		_oProcess.onTargeting.attach( this );
		_oProcess.onFiring.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor

	public function rangeMax_get() {
		return _oType.rangeMax_get();
	}

	
	public function cooldown_get() { return _oCooldown; }

//______________________________________________________________________________
//	Accessor
	
	function target_set( oTarget :Unit ) :Void {
		_oTarget = oTarget;
	}
	
	public function target_suggest( oTarget :Unit ) :Bool {
		
		// Pass if already got a target, or suggested target is invalid
		if( _oTarget != null || !target_check( oTarget ) ) 
			return false;
		
		target_set( oTarget );
		return true;
	}
	
	public function target_get() :Unit {
		return _oTarget;
	}
	
	
//______________________________________________________________________________
//	Update
	/*
	public function update() {
		// Update target
		target_update();
		
		
	}*/
	
//______________________________________________________________________________
//	Sub-routine
	
	function _fire() {
		
		//Trigger
		onFire.dispatch( this );
		
		// Check target exist
		if ( _oTarget == null ) 
			return;
		
		// Set cooldown
		_oCooldown.reset();
		
		// Apply damage
		var oHealth = _oTarget.ability_get( Health );
		oHealth.damage( _oType.power_get(), _oType.damageType_get() );
	}
	
	function target_update() {
		// Reset target if no longer valid
		if( !target_check( _oTarget ) ) 
			target_set( null );
	}
	
	//TODO : Replace by collision layer
	function swipe_target() {
		
		// Update current target
		target_update();
		
		// Look for better target
		for ( oTarget in _oUnit.mygame_get().entity_get_all() ) 
			if( Std.is( oTarget, Unit ) )
				target_suggest( cast oTarget );
	}
	
	function target_check( oTarget :Unit ) :Bool {
		return _oType.target_check( this, oTarget );
	}
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) {
		if( oSource == _oProcess.onTargeting )
			swipe_target();
		
		if ( oSource == _oProcess.onFiring ) {
			// Fire on cooldown expire
			if( _oCooldown.expired_check() ) {
				
				_fire();
			}
		}
			
	}
//______________________________________________________________________________
//	Process
	

	
//______________________________________________________________________________
//	Disposer

	override public function dispose() {
		
		// Stop listening
		_oProcess.onTargeting.remove( this );
		_oProcess.onFiring.remove( this );
		
		// Wipe all
		super.dispose();
		
	}
}