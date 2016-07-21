package mygame.client.view;

import mygame.client.model.Model;
import mygame.client.model.UnitSelection;
import js.html.DivElement;
import js.html.Element;
import mygame.client.view.html.BlockRoster;
import mygame.client.view.html.BlockUnitSelection;
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
	
	var _oBlockRoster :BlockRoster;
	var _oBlockUnitSelection :BlockUnitSelection;
	
	var _oLabelErrorLog :Element;

//______________________________________________________________________________
//	Constructor

	public function new( oModel :Model ) {
		_oModel = oModel;
		_oContainer = js.Browser.document.getElementById('GameMenu');
		_oContainer.style.removeProperty('display');
		
		_oCreditLabel = js.Browser.document.getElementById('Credit');

		_oBuildContainer = js.Browser.document.getElementById('Build');

		_oSelectionList = js.Browser.document.getElementById('SelectionList');
		_oBuildList = js.Browser.document.getElementById('BuildList');
		
		_oLabelErrorLog = js.Browser.document.getElementById('game-errorlog');

		// Update 
		credit_update();
		//selectionList_update();
		
		// Trigger
		_oSelection = _oModel.GUI_get().unitSelection_get();
		_oSelection.onUpdate.attach( this );
		_oModel.game_get().onCreditAnyUpdate.attach( this );
		//_oModel.playerLocal_get().onUpdate.attach( this );
		
		_oBlockRoster = new BlockRoster( _oModel, js.Browser.document.getElementById('roster-wrapper') );
		
		_oBlockUnitSelection = new BlockUnitSelection( 
			_oModel, 
			js.Browser.document.getElementById('selection-wrapper')
		);
		
	}
	
//______________________________________________________________________________
//	Accessor

	public function build_hide() { _oBuildContainer.style.visibility = 'hidden'; }
	public function build_show() { _oBuildContainer.style.removeProperty('visibility'); }
//______________________________________________________________________________
//	Modifier
	
	public function errorlog_set( sError :String ) {
		_oLabelErrorLog.innerHTML = '';
		_oLabelErrorLog.innerHTML = '<span class="fade-out">'+sError+'</span>';
	}
	
//______________________________________________________________________________
//	
	
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
		return '<button class="btn-icon">'+sName+'<span>'+iQuantity+'</span></button>';
	}
	
	function pattern_buildButton( iId :Int, sName :String, iCost :Int ) :String {
		return '<button class="btn-icon Sale" data-sale="'+iId+'">'+sName+'<span>-'+iCost+' C</span></button>';
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
		if ( oSource == _oModel.game_get().onCreditAnyUpdate ) {
			this.credit_update();
		}
		if( oSource == _oSelection.onUpdate ) {
			//selectionList_update();
		}
		/*if( oSource == _oModel.playerLocal_get().onUpdate ) {
			selectionList_update();
		}*/
	}
}