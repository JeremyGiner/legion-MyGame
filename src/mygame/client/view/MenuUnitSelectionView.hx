package mygame.client.view;

import mygame.client.model.UnitSelection;
import js.html.DivElement;
import trigger.*;

import mygame.game.ability.BuilderFactory;

class MenuUnitSelectionView implements ITrigger {
	
	var _oDiv :DivElement;
	var _oSelection :UnitSelection;

//______________________________________________________________________________
//	Constructor

	public function new( oSelection :UnitSelection, oDiv :DivElement ) {
		_oSelection = oSelection;
		_oDiv = oDiv;
		_oSelection.onUpdate.attach( this );
		update();
	}
	
//______________________________________________________________________________
//	
	
	function update() {
		
		// Cleaning
		_oDiv.innerHTML = '';
		
		// Get html code from unit selection and pattern
		var s :String = '';
		var oSelection = _oSelection.unitSelection_get();
		for( sUnitType in oSelection.keys() ) {
			if( oSelection.get( sUnitType ).length > 0 ) {
			
				// Get selection button
				s += pattern( 
					className_get_fromFullName(sUnitType), 
					oSelection.get( sUnitType ).length 
				);
				
				// Get Builder menu
				var oBuilder = oSelection.get( sUnitType ).first().ability_get( BuilderFactory );
				if( oBuilder != null ) {
					var aOffer = oBuilder.offerArray_get();
					for( iOfferId in 0...aOffer.length )
						s += pattern_builder(
							iOfferId,
							aOffer[iOfferId].name_get(),
							aOffer[iOfferId].cost_get()
						);
				}
			}
		}
		
		// Print
		_oDiv.innerHTML = s;
		
		
	}
	
	function pattern( sName :String, iQuantity :Int ) :String {
		return '<button>'+sName+'<span>'+iQuantity+'</span></button>';
	}
	function pattern_builder( iId :Int, sName :String, iCost :Int ) :String {
		return '<button class="Sale" data-sale="'+iId+'">'+sName+'<span>-'+iCost+' C</span></button>';
	}
	
	function className_get_fromFullName( s :String ) {
		var a = s.split('.');
		return a[a.length-1];	//Get last term
	}
	
//______________________________________________________________________________
//	Trigger
	
	public function trigger( oSource :IEventDispatcher ) {
		if( oSource == _oSelection.onUpdate ) {
			update();
		}
	}
}