package mygame.game.ability;

import legion.ability.IAbility;
import mygame.game.entity.Unit;
import mygame.game.misc.weapon.EDamageType;
import trigger.*;

class Health extends UnitAbility {
	var _fCurrent :Float;
	var _fMax :Float;
	var _bArmored :Bool;
	
	public var onUpdate :EventDispatcherTree<Health>;
	
//______________________________________________________________________________
//	Constructor

	public function new( 
		oUnit :Unit, 
		bArmored :Bool = false, 
		fMax :Float = 100, 
		fCurrent :Float = 100
	) {
		super( oUnit );
		
		_fCurrent = fCurrent;
		_fMax = fMax;
		_bArmored = bArmored;
		
		onUpdate = new EventDispatcherTree<Health>( oUnit.mygame_get().onHealthAnyUpdate );
	}

//______________________________________________________________________________
//	Accessor
	
	public function get():Float{ return _fCurrent; };
	
	
	public function max_get():Float{
		return _fMax;
	}
	
	public function armored_check() {
		return _bArmored;
	}
	
//______________________________________________________________________________
//	Modifier
	
	public function max_set( fHealthMax :Float ):Void {
		// TODO: clamp max between [0;inf+]?
		_fMax = fHealthMax;
		
		// Dispatch
		onUpdate.dispatch( this );
	}
	
	public function set( fHealthCurrent :Float ):Void { 
		// Clamp between [0;fMax]
		_fCurrent = Math.min( Math.max( fHealthCurrent, 0), _fMax);
		
		// Dispatch
		onUpdate.dispatch( this );
	}
	
//______________________________________________________________________________
//	Shortcut

	public function percent_set( fPercent :Float ):Void{
		set( fPercent*_fMax );
	}
	public function percent_get():Float{
		return _fCurrent/_fMax;
	}
	
//______________________________________________________________________________
//	
	public function damage( fDamage :Float, eDamageType :EDamageType ) {
		
		// Cancel bullet damage if armored 
		if( _bArmored && eDamageType == EDamageType.Bullet )
			return;
		
		// Else normal damage
		set( get() - fDamage );
	}

}