package mygame.game.misc.offer;

import legion.ability.IAbility;
import mygame.game.entity.Player;
import legion.entity.Entity;

class Offer {

	var _sName :String;
	var _iCost :Int;
	
//______________________________________________________________________________
//	Constructor

	public function new( iCost :Int, sName :String ) {
		_sName = sName;
		_iCost = 10;
	}

//______________________________________________________________________________
//	Accessor
	
	public function cost_get() { return _iCost; }
	public function name_get() { return _sName; }
	
	public function accept( oBuyer :Player, oSeller :Entity ) :Void { 
		oBuyer.credit_add( -_iCost );
	}

}