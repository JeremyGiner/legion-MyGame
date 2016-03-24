package mygame.client.view;

import mygame.client.model.Model;
import mygame.client.model.UnitSelection;
import js.html.DivElement;
import js.html.Element;
import trigger.*;

import mygame.game.ability.BuilderFactory;

class GameMenu implements ITrigger {
	
	var _oModel :Model;
	var _oContainer :Element;
	
	var _oBuildContainer :Element;
	var _oBuildList :Element;	// Dynamic content
	
	var _oSelectionList :Element;	// Dynamic content
	
	var _oCreditLabel :Element; // Dynamic content
	
	var _oSelection :UnitSelection;

//______________________________________________________________________________
//	Constructor

	public function new( oModel :Model ) {
		_oModel = oModel;
		_oContainer = js.Browser.document.getElementById('GameMenu');
		
		_oCreditLabel = js.Browser.document.getElementById('Credit');

		_oBuildContainer = js.Browser.document.getElementById('Build');

		_oSelectionList = js.Browser.document.getElementById('SelectionList');
		_oBuildList = js.Browser.document.getElementById('BuildList');

		// Update 
		credit_update();
		selectionList_update();
		
		// Trigger
		_oSelection = _oModel.GUI_get().unitSelection_get();
		_oSelection.onUpdate.attach( this );
		_oModel.playerLocal_get().onUpdate.attach( this );
		
	}
	
//______________________________________________________________________________
//	Accessor

	public function build_hide() { _oBuildContainer.style.visibility = 'hidden'; }
	public function build_show() { _oBuildContainer.style.removeProperty('visibility'); }

//______________________________________________________________________________
//	
	
	function selectionList_update() {
		
		// Cleaning
		_oSelectionList.innerHTML = '';
		
		// Get html code from unit selection and pattern
		var s :String = '';
		var oSelection = _oModel.GUI_get().unitSelection_get().unitSelection_get();
		for( sUnitType in oSelection.keys() ) {
			if( oSelection.get( sUnitType ).length > 0 ) {
			
				// Get selection button
				s += pattern_selectButton( 
					className_get_fromFullName(sUnitType), 
					oSelection.get( sUnitType ).length 
				);
				
				// Get Builder menu
				var oBuilder = oSelection.get( sUnitType ).first().ability_get( BuilderFactory );
				if( oBuilder != null ) {
					build_show();
					buildList_update( oBuilder );
				} else
					build_hide();
			}
		}
		
		// Print
		_oSelectionList.innerHTML = s;
	}
	
	function buildList_update( oBuilder :BuilderFactory ) {
		
		// Cleaning
		_oBuildList.innerHTML = '';
		
		// Get Builder menu
		var s :String = '';
		var aOffer = oBuilder.offerArray_get();
		for( iOfferId in 0...aOffer.length )
			s += pattern_buildButton(
				iOfferId,
				aOffer[iOfferId].name_get(),
				aOffer[iOfferId].cost_get()
			);
		
		// Print
		_oBuildList.innerHTML = s;
		
	}
	
	function pattern_selectButton( sName :String, iQuantity :Int ) :String {
		return '<button>'+sName+'<span>'+iQuantity+'</span></button>';
	}
	
	function pattern_buildButton( iId :Int, sName :String, iCost :Int ) :String {
		return '<button class="Sale" data-sale="'+iId+'">'+sName+'<span>-'+iCost+' C</span></button>';
	}
	function className_get_fromFullName( s :String ) {
		var a = s.split('.');
		return a[ a.length-1 ];	//Get last term
	}
	
	function credit_update() {
		// Cleaning
		_oCreditLabel.innerHTML = '';
		
		// Print
		_oCreditLabel.innerHTML = credit_pattern( _oModel.playerLocal_get().credit_get() );
	}
	
	function credit_pattern( iCredit :Int ) :String {
		return '<span>'+iCredit+'</span>';
	}
	
//______________________________________________________________________________
//	Trigger
	
	public function trigger( oSource :IEventDispatcher ) {
		if( oSource == _oSelection.onUpdate ) {
			selectionList_update();
		}
		if( oSource == _oModel.playerLocal_get().onUpdate ) {
			selectionList_update();
		}
	}
}