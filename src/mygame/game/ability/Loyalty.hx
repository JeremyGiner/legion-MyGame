package mygame.game.ability;

import mygame.game.entity.Unit;
import mygame.game.entity.Player;
import trigger.EventDispatcher2;

/**
 * ...
 * @author GINER Jérémy
 */
class Loyalty extends UnitAbility {
	
	var _oOwner :Player;
	
	public var onUpdate :EventDispatcher2<Loyalty>;
	
//______________________________________________________________________________
//	Constructor

	public function new( oUnit :Unit, oPlayer :Player ) {
		
		super( oUnit );
		_oOwner = oPlayer;
		
		onUpdate = new EventDispatcher2<Loyalty>();
		onUpdate.attach( _oUnit.mygame_get().onLoyaltyAnyUpdate );
	}

//______________________________________________________________________________
//	Accessor
	
	public function owner_get() { return _oOwner; }
	
//______________________________________________________________________________
//	Accessor
	
	public function owner_set( oPlayer :Player ) { 
		_oOwner = oPlayer; 
		onUpdate.dispatch( this );
		return this; 
	}

}