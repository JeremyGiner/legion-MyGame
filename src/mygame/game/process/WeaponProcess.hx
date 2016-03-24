package mygame.game.process;

import legion.entity.Entity;
import mygame.game.MyGame;
import mygame.game.ability.Weapon;
import mygame.game.entity.Unit;
import mygame.game.collision.WeaponLayer;

import trigger.*;

class WeaponProcess implements ITrigger {

	var _oGame :MyGame;
	var _lWeapon :List<Weapon>;
	
	//var _oCollisionLayer :WeaponLayer;
	
	public var onTargeting :EventDispatcher2<MyGame>;
	public var onFiring :EventDispatcher2<MyGame>;

//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame ) {
		_oGame = oGame;
		_lWeapon = new List<Weapon>();
		//_oCollisionLayer = new WeaponLayer();
		
		onTargeting = new EventDispatcher2<MyGame>();
		onFiring = new EventDispatcher2<MyGame>();
		
		_oGame.onLoop.attach( this );
		//_oGame.onEntityNew.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor
	
	public function entity_add( oEntity :Entity ) :Bool {
		if( Std.is( oEntity, Unit ) ) {
			var oUnit :Unit = cast oEntity;
			var oWeapon = oUnit.ability_get(Weapon);
			if( oWeapon != null ) 
				_lWeapon.push( oWeapon );
				//_oCollisionLayer.add( oUnit );
			return true;
		}
		
		return false;
	}
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		// on loop
		if( oSource == _oGame.onLoop ) {
			onTargeting.dispatch(_oGame);
			onFiring.dispatch(_oGame);
		}
		
		// on new weaponed entity
		/*if( oSource == _oGame.onEntityNew ) {
			entity_add( cast oSource.event_get() );
		}*/
		
	
	}
}