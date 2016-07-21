package mygame.game.action;

import mygame.game.ability.Guidance;
import mygame.game.ability.Roster;
import mygame.game.entity.Unit;
import legion.entity.Player;
import legion.PlayerInput;

import mygame.game.ability.BuilderFactory;

import space.Vector3 in Vector2;

class RosterOrderBuy implements IAction {

	var _oPlayer :Player;
	var _iOfferIndex :Int;
	
//______________________________________________________________________________
//	Constructor

	public function new( 
		oPlayer :Player,
		iOfferIndex :Int
	) {
		_oPlayer = oPlayer;
		_iOfferIndex = iOfferIndex;
	}
	
//______________________________________________________________________________
// Utils
	
	public function exec( oGame :MyGame ) {
		if ( !check( oGame ) ) throw('invalid input');
		
		_oPlayer.ability_get(Roster).build( _iOfferIndex );
	}
	
	public function check( oGame :MyGame ) :Bool {
		
		// Case : unit already bought
		if ( _oPlayer.ability_get(Roster).activeUnit_get( _iOfferIndex ) != null ) return false;
		
		// Check credit
		if ( Roster.price_get(_oPlayer.ability_get(Roster).unitType_get(_iOfferIndex) ) > untyped _oPlayer.credit_get() )
			return false;
		
		// TODO: check if roster factory available
		return true;
	}
	
}