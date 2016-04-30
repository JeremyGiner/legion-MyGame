package mygame.client.view.html;

import js.html.Element;
import mygame.client.model.UnitSelection;
import js.html.DivElement;
import mygame.client.model.RoomInfo;
import mygame.game.GameConf;
import trigger.*;
import trigger.eventdispatcher.EventDispatcher;
import utils.MapTool;
import mygame.game.ability.BuilderFactory;

import mygame.client.model.Model;

/**
 * @author GINER Jérémy
 */
class BlockUnitSelection implements ITrigger {
	
	var _oDiv :Element;
	var _oBuildContainer :Element;
	var _oBuildList :Element;
	var _oSelectionList :Element;
	var _oModel :Model;

//______________________________________________________________________________
//	Constructor

	public function new( oModel :Model, oDiv :Element ) {
		_oModel = oModel;
		_oDiv = oDiv;
		
		_oBuildContainer = js.Browser.document.getElementById('Build');
		_oBuildList = js.Browser.document.getElementById('BuildList');
		_oSelectionList = js.Browser.document.getElementById('SelectionList');
		
		_oModel.GUI_get().unitSelection_get().onUpdate.attach( this );
		//_oModel.playerLocal_get().onUpdate.attach( this );
		
		update();
	}
	
//______________________________________________________________________________
//	Updater
	
	public function update() {
		
		// Cleaning
		//_oDiv.innerHTML = '';
		
		// Print
		//_oDiv.innerHTML = _render();
		_oSelectionList.innerHTML = _render();
		
	}

//______________________________________________________________________________
//	Sub-routine
	
	function _render() :String {
		
		var oSelection = _oModel.GUI_get().unitSelection_get().unitSelection_get();
		
		// Check length
		if ( MapTool.getLength( oSelection ) == 0 )
			return '';
		
		// Get html code from unit selection and pattern
		var s = '';
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
		return s;
	}
	
	/**
	 * NOT USED
	 */
	function _menuSelection_render() {
		return '<fieldset id="Selection">
			<legend>Selection</legend>
			<div id="SelectionList"></div>
		</fieldset>';
	}
	
	/**
	 * NOT USED
	 */
	function _menuBUild_render() {
		return '<fieldset id="Build">
			<legend>Build unit</legend>
			<div id="BuildList"></div>
		</fieldset>';
	}
	
	function pattern_selectButton( sName :String, iQuantity :Int ) :String {
		return '<button class="btn-icon">'+sName+'<span>'+iQuantity+'</span></button>';
	}
	
	function pattern_buildButton( iId :Int, sName :String, iCost :Int ) :String {
		return '<button class="btn-icon Sale" data-sale="'+iId+'">'+sName+'<span>-'+iCost+' C</span></button>';
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
	
	public function build_hide() { _oBuildContainer.style.visibility = 'hidden'; }
	public function build_show() { _oBuildContainer.style.removeProperty('visibility'); }

//______________________________________________________________________________
//	Trigger
	
	public function trigger( oSource :IEventDispatcher ) {
		// On room status update
		update();
	}
	
//______________________________________________________________________________
//	Utils
	
	function className_get_fromFullName( s :String ) {
		var a = s.split('.');
		return a[ a.length-1 ];	//Get last term
	}
}