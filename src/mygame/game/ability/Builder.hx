package mygame.game.ability;

import legion.ability.IAbility;
import mygame.game.entity.Unit;
import mygame.game.misc.offer.Offer;

class Builder extends UnitAbility {

	var _oProduct :Array<Offer>;
	
//______________________________________________________________________________
//	Constructor

	public function new( oUnit :Unit ) {
		super( oUnit );
		_oProduct = new Array<Offer>();
	}

//______________________________________________________________________________
//	Accessor
	
	public function product_add( oOffer :Offer ) :Void { 
		
	}
	
	public function productArray_get() { return _oProduct; };
	
//______________________________________________________________________________
//	Shortcut

}