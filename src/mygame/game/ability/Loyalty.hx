package mygame.game.ability;

import legion.entity.Entity;
import mygame.game.entity.Unit;
import mygame.game.entity.Player;
import trigger.EventDispatcher2;

/**
 * ...
 * @author GINER Jérémy
 */
class Loyalty extends EntityAbility {
	
	var _oOwner :Player;
	
	public var onUpdate :EventDispatcher2<Loyalty>;
	
//______________________________________________________________________________
//	Constructor

	public function new( oEntity :Entity, oPlayer :Player ) {
		
		super( oEntity );
		_oOwner = oPlayer;
		
		onUpdate = new EventDispatcher2<Loyalty>();
		onUpdate.attach( untyped _oEntity.game_get().onLoyaltyAnyUpdate );
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