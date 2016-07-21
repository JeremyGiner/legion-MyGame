package mygame.game.ability;

import legion.ability.IAbility;
import legion.entity.Entity;
import mygame.game.entity.Projectile;
import mygame.game.entity.Unit;
import mygame.game.ability.Position;
import mygame.game.ability.Health;
import mygame.game.misc.Hit;
import mygame.game.misc.weapon.EDamageType;
import mygame.game.misc.weapon.IWeaponType;
import mygame.game.misc.weapon.TargetValidator;
import mygame.game.process.WeaponProcess;
import mygame.game.query.EntityQuery;
import mygame.game.query.EntityDistance;
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
	var _oTarget :Entity;
	var _oCooldown :Timer;

//____

	public var onFire :EventDispatcher2<Weapon>;

//______________________________________________________________________________
//	Constructor

	public function new( oOwner :Unit, oType :IWeaponType ) {
		super( oOwner );
		
		_oTarget = null;
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
	
	public function target_get() {
		_target_update();
		return _oTarget;
	}
	
	public function type_get() {
		return _oType;
	}
//______________________________________________________________________________
//	Modifier

	public function target_suggest( oTarget :Unit ) :Bool {
		
		// Pass if already got a target, or suggested target is invalid
		if( _oTarget != null || !_oType.target_check( this, oTarget ) ) 
			return false;
		
		
		return true;
	}
	
	public function target_set( oTarget ) {
		_oTarget = oTarget;
	}

//______________________________________________________________________________
//	Sub-routine
	
	function _fire() {
		
		//Trigger
		onFire.dispatch( this );
		
		// Set cooldown
		_oCooldown.reset();
		
		// Case : shell -> create projectile
		if ( _oType.damageType_get() == EDamageType.Shell ) {
			var oPos = _oUnit.ability_get(Position);
			var oTargetPos = _oTarget.ability_get(Position);
			_oUnit.game_get().entity_add( new Projectile( cast _oUnit.game_get(), oPos.x, oPos.y, oTargetPos.clone() ) );
			return;
		}
		
		// Apply hit
		_oUnit.game_get().singleton_get(WeaponProcess).hit_add( 
			new Hit(
				_oTarget.identity_get(),
				Math.round( _oType.power_get() ), //TODO put power in int
				_oType.damageType_get()
			)
		);
	}
	
	function _target_update() {
		// Reset target if no longer valid
		if( !_oType.target_check( this, _oTarget ) ) 
			_oTarget = null;
	}
	
	
//______________________________________________________________________________
//	Process

	/*public function swipe_target() {
		
		// Update current target
		_target_update();
		
		// Check if new target needed
		if ( _oTarget != null )
			return;
		
		// Look for better target
		
		for ( oTarget in _oUnit.mygame_get().singleton_get(EntityDistance).entityList_get_byProximity( _oUnit, _oType.rangeMax_get() ) ) {
			if ( _oType.target_check( this, oTarget ) ) {
				_oTarget = cast oTarget;
				break;
			}
		}
	}*/
	
	public function fire() {
		// Fire on cooldown expire
		if( _oCooldown.expired_check() && target_get() != null ) {
			_fire();
		}
	}
}