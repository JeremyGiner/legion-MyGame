package mygame.client.view.html;

import js.html.Element;
import mygame.client.model.UnitSelection;
import js.html.DivElement;
import mygame.client.model.RoomInfo;
import mygame.game.ability.Roster;
import mygame.game.GameConf;
import trigger.*;
import trigger.eventdispatcher.EventDispatcher;
import utils.MapTool;
import mygame.game.ability.BuilderFactory;

import mygame.client.model.Model;

/**
 * Group of button displaying possible roster interaction ( buy / select unit )
 * @author GINER Jérémy
 */
class BlockRoster implements ITrigger {
	
	var _oDiv :Element;
	var _oModel :Model;
	
	var _bUpdateRequired :Bool;
	
	// Cache
	
	var _oRoster :Roster;

//______________________________________________________________________________
//	Constructor

	public function new( oModel :Model, oDiv :Element ) {
		_bUpdateRequired = true;
		_oModel = oModel;
		_oDiv = oDiv;
		
		// TODO : set roster on current player
		_oRoster = _oModel.game_get().player_get( 0 ).ability_get(Roster); 
		
		_oModel.game_get().onEntityNew.attach( this );
		_oModel.game_get().onLoopEnd.attach( this );
		//_oModel.playerLocal_get().onUpdate.attach( this );
		
		update();
	}
	
//______________________________________________________________________________
//	Updater
	
	public function update() {
		
		_oDiv.innerHTML = _render();
		
		_bUpdateRequired = false;
	}

//______________________________________________________________________________
//	Sub-routine
	
	function _render() :String {
		return '
		<fieldset id="Selection">
			<legend>Roster</legend>
			<div>'+_listButton_render()+'</div>
		</fieldset>';
	}
	
	function _listButton_render() {
		var s = '';
		var aUnitType = _oRoster.unitType_get_all();
		for ( i in 0...aUnitType.length ) {
			var sUnitTypeName = unitTypeName_get( aUnitType[i] );
			if ( _oRoster.activeUnit_get(i) == null ) {
				// Case : no active unit -> buy button
				s += _buttonBuild_render( i, sUnitTypeName, Roster.price_get(aUnitType[i]) );
			} else {
				// Case : select active unit
				s += _buttonSelect_render( sUnitTypeName, _oRoster.activeUnit_get(i).identity_get() );
			}
		}
		return s;
	}
	
	function _buttonSelect_render( sName :String, iId :Int ) :String {
		return '<button class="btn-icon" data-haxeaction="unit-select" data-unit_id="'+iId+'">'+sName+'<span>1</span></button>';
	}
	
	function _buttonBuild_render( iId :Int, sName :String, iCost :Int ) :String {
		return '<button class="btn-icon Sale" data-haxeaction="roster-buy" data-roster_id="'+iId+'">'+sName+'<span>-'+iCost+' C</span></button>';
	}
	
//______________________________________________________________________________
//	Trigger
	
	public function trigger( oSource :IEventDispatcher ) {
		// Update on loop end after an new entity
		if ( oSource == _oModel.game_get().onEntityNew ) {
			_bUpdateRequired = true;
			return;
		}
		if ( oSource == _oModel.game_get().onLoopEnd && _bUpdateRequired == true ) {
			update();
		}
	}
	
//______________________________________________________________________________
//	Utils
	
	function unitTypeName_get( s :String ) {
		var a = s.split('.');
		return a[ a.length-1 ];	//Get last term
	}
}