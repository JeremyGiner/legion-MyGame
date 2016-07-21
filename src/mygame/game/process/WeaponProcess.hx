package mygame.game.process;

import legion.entity.Entity;
import mygame.game.ability.Health;
import mygame.game.ability.Loyalty;
import mygame.game.ability.Position;
import mygame.game.misc.IHit;
import mygame.game.misc.weapon.TargetValidator;
import mygame.game.MyGame;
import mygame.game.ability.Weapon;
import mygame.game.entity.Unit;
import legion.IQuery;
import mygame.game.query.CascadingEntityList;
import mygame.game.query.EntityDistance;
import mygame.game.query.EntityDistanceTile;
import mygame.game.query.EntityQuery;
import mygame.game.query.EntityQueryAdv;
import mygame.game.query.EntityDistance;
import mygame.game.query.ValidatorEntity;
import mygame.game.utils.validatorentity.ValiAbility;
import mygame.game.utils.validatorentity.ValiAllianceEntity;
import mygame.game.utils.validatorentity.ValiEntityInArray;
import mygame.game.utils.validatorentity.ValiInRangeEntity;
import mygame.game.utils.validatorentity.ValiInRangeEntityByTile;
import mygame.game.utils.validatorentity.ValiNotEntity;
//import mygame.game.query.EntityQueryAdv;
import haxe.ds.IntMap;

import legion.entity.Player;

import trigger.*;

private typedef Query = IQuery<Dynamic,Dynamic,IntMap<Entity>>;

class WeaponProcess implements ITrigger {

	var _oGame :MyGame;
	
	var _oQueryWeapon :EntityQuery;
	
	/**
	 * List of valid target for each entity
	 * Indexed by entity id
	 */
	var _aQueryPossibleTarget :Map<Int,CascadingEntityList>;
	
	var _lHit :List<IHit>;
	
	public var onHit :EventDispatcher2<IHit>;

//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame ) {
		_lHit = new List<IHit>();
		
		_oGame = oGame;
		_oQueryWeapon = new EntityQuery( _oGame, new ValidatorEntity([ 'ability' => Weapon ]) );
		
		_aQueryPossibleTarget = new Map<Int,CascadingEntityList>();
		
		_oGame.onLoop.attach( this );
		
		// for query dispose
		_oGame.onEntityDispose.attach(this);
		
		onHit = new EventDispatcher2<IHit>();
	}
//______________________________________________________________________________
//	Modifier
	
	public function hit_add( oHit :IHit ) {
		_lHit.add( oHit );
	}

//______________________________________________________________________________
//	Process

	function _target_process() {
		// Process targeting for each
		for ( oEntity in _oQueryWeapon.data_get(null) ) {
			var oWeapon = oEntity.ability_get(Weapon);
			
			// Check if new target needed
			if ( oWeapon.target_get() != null )
				continue;
			
			// Look for target
			var aValidTarget = _queryValidTarget_get( oWeapon ).get();
			for ( oTarget in aValidTarget ) { //Basicly set target to the first on the list
				if( oWeapon.type_get().target_check( oWeapon, oTarget ) ) {
					oWeapon.target_set( oTarget );
					break;
				}
			}
		}
		
		
	}
	
	function _hit_process() {
		// Process each hit
		var oHit = null;
		while ( (oHit = _lHit.pop()) != null ) {
			var oTarget = _oGame.entity_get( oHit.targetId_get() );
			
			if ( oTarget == null )
				continue;
			
			var oHealth = oTarget.ability_get( Health );
			
			if ( oHealth == null )
				continue;
			
			// Apply hit
			oHealth.damage( oHit.damage_get(), oHit.damageType_get() );
			onHit.dispatch( oHit );
		}
	}
	
//______________________________________________________________________________
//	Sub-routine

	function _queryValidTarget_get( oWeapon :Weapon ) {
		var iKey = oWeapon.unit_get().identity_get();
		if ( !_aQueryPossibleTarget.exists( iKey ) ) {
			/*
			var oEntityQuery = new EntityQuery( 
				_oGame, 
				new TargetValidator( oWeapon ), 
				[_oGame.singleton_get(EntityDistance).onUpdate ]
			); 
			*/
			var o = new CascadingEntityList( 
				_oGame, 
				[
					new ValiAbility( Health ),
					new ValiAbility( Position ),
					new ValiAbility( Loyalty ),
					new ValiAllianceEntity( oWeapon.unit_get(), ALLIANCE.ennemy ),
					new ValiInRangeEntityByTile( oWeapon.unit_get(), oWeapon.type_get().rangeMax_get() ),
					new ValiInRangeEntity( oWeapon.unit_get(), oWeapon.type_get().rangeMax_get() ),
					new ValiNotEntity( oWeapon.unit_get() )
					//TODO : Soldier specific : armor test
				]
			);
			/*
			var oEntityQuery = new EntityQueryAdv( 
				_oGame, 
				[
					new ValiAllianceEntity( oWeapon.unit_get(), ALLIANCE.ennemy ),
					new ValiAbility( Health ),
					new ValiInRangeEntityByTile( oWeapon.unit_get(), oWeapon.type_get().rangeMax_get() ),
					new ValiInRangeEntity( oWeapon.unit_get(), oWeapon.type_get().rangeMax_get() ),
					new ValiNotEntity( oWeapon.unit_get() )
					//TODO : Soldier specific : armor test
				], 
				[
					_oGame.onLoyaltyAnyUpdate,
					_oGame.onEntityAbilityAdd,
					_oGame.onEntityAbilityRemove,
					_oGame.singleton_get(EntityDistanceTile).onUpdate,
					_oGame.onPositionAnyUpdate//_oGame.singleton_get(EntityDistance).onUpdate//_oGame.singleton_get(EntityDistance).onUpdate
				],
				[
					[0],
					[0,1],
					[0,1],
					[2],
					[3]
				],
				[
					null,
					null,
					null,
					null
				]
			);*/
			_aQueryPossibleTarget.set(iKey, o);
			return o;
		} else
			return _aQueryPossibleTarget.get( iKey );
	}

//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		// ON entity dispose -> 
		if ( oSource == _oGame.onEntityDispose ) {
			var oEntity = _oGame.onEntityDispose.event_get();
			
			if ( oEntity.ability_get(Weapon) == null )
				return;
			
			var iId = oEntity.identity_get();
			untyped _aQueryPossibleTarget.get( iId ).dispose();
			_aQueryPossibleTarget.remove( iId );
			
			return;
		}
		
		// on loop
		if ( oSource == _oGame.onLoop ) {
			var aEntity = _oQueryWeapon.data_get(null);
			
			// Targeting
			_target_process();
			/*for ( oEntity in aEntity ) {
				oEntity.ability_get(Weapon).swipe_target();
			}*/
			
			// Firing
			for ( oEntity in aEntity ) {
				oEntity.ability_get(Weapon).fire();
			}
			
			// HIt process 
			_hit_process();
			
			return;
		}
		
	
	}
}