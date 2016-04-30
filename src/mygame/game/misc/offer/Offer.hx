package mygame.game.misc.offer;

import legion.ability.IAbility;
import mygame.game.entity.Player;
import legion.entity.Entity;

class Offer<CData> {

	var _sName :String;
	var _iCost :Int;
	var _oData :CData;
	
//______________________________________________________________________________
//	Constructor

	public function new( iCost :Int, sName :String, oData :CData = null ) {
		_sName = sName;
		_iCost = 10;
		_oData = oData;
	}

//______________________________________________________________________________
//	Accessor
	
	public function cost_get() { return _iCost; }
	public function name_get() { return _sName; }
	public function data_get() :CData {
		return _oData;
	}
	/*
	public function accept( oBuyer :Player, oSeller :Entity ) :Void { 
		oBuyer.credit_add( -_iCost );
	}*/

}