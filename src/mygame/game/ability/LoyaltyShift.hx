package mygame.game.ability;

import haxe.ds.IntMap;
import legion.ability.IAbility;
import mygame.game.query.EntityQuery;
import space.Circle;
import space.Circlei;
import space.Vector2i;
import space.Vector3;
import mygame.game.ability.Position;
import mygame.game.entity.Unit;
import mygame.game.entity.Player;
//import mygame.game.collision.LoyaltyShiftLayer in CollisionLayer;

import collider.CollisionCheckerPostInt;

class LoyaltyShift extends UnitAbility {
	
	var _fLoyalty :Float; //Percent
	var _oChallenger :Player;
	
	static var _fStep :Float = 0.01; // Must be inferior to 0.5
	
//______________________________________________________________________________
//	Constructor

	public function new( oUnit :Unit ) {
		
		
		//require position
		super( oUnit );
		_fLoyalty = 1;
		_oChallenger = _oUnit.owner_get();
		if( _oChallenger == null )
			_fLoyalty = 0;
	}

//______________________________________________________________________________
//	Accessor
	
	public function radius_get() {
		return 10000;
	}
	
	public function loyalty_get() { return _fLoyalty; }
	public function challenger_get() { return _oChallenger; }
//______________________________________________________________________________
//	Modifier

	public function challenger_set( oPlayer :Player ) {
		_oChallenger = oPlayer;
	}
	
//______________________________________________________________________________
//	Sub-routine

	public function loyalty_increase() {
		_fLoyalty += _fStep;
		if( _fLoyalty >= 0.5 ) 
			_oUnit.ability_get(Loyalty).owner_set( _oChallenger );
		_fLoyalty = Math.min( _fLoyalty, 1 );
	}
	public function loyalty_decrease() {
		_fLoyalty -= _fStep;
		if( _fLoyalty < 0.5 ) 
			_oUnit.ability_get(Loyalty).owner_set( null );
		_fLoyalty = Math.max( _fLoyalty, 0 );
	}
	

}