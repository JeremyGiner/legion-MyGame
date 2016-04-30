package mygame.client.view;

import mygame.client.model.UnitSelection;
import js.html.DivElement;
import trigger.*;

import mygame.client.model.Model;

class MenuCredit implements ITrigger {
	
	var _oDiv :DivElement;
	var _oModel :Model;

//______________________________________________________________________________
//	Constructor

	public function new( oModel :Model, oDiv :DivElement ) {
		_oModel = oModel;
		_oDiv = oDiv;
		
		update();
		
		//_oModel.playerLocal_get().onUpdate.attach( this );
	}
	
//______________________________________________________________________________
//	
	
	function update() {
		
		// Cleaning
		_oDiv.innerHTML = '';
		
		// Print
		_oDiv.innerHTML = pattern( _oModel.playerLocal_get().credit_get() );
	}
	
	function pattern( iCredit :Int ) :String {
		return '<span>'+iCredit+'</span>';
	}
	
//______________________________________________________________________________
//	Trigger
	
	public function trigger( oSource :IEventDispatcher ) {
		//if( oSource == _oPlayer.onUpdate ) {
			update();
		//}
	}
}