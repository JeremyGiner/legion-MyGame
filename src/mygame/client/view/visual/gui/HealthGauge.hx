package mygame.client.view.visual.gui;

import js.three.*;
import trigger.*;

import mygame.client.model.GUI;
import mygame.client.view.visual.EntityVisual;
import mygame.client.view.visual.unit.UnitVisual;
//import mygame.client.view.GameView;
import mygame.game.ability.Health;

import trigger.*;

class HealthGauge extends UnitGauge {
	
	var _oHealth :Health;
	
//______________________________________________________________________________
//	Constructor

	public function new( oUnitVisual :UnitVisual<Dynamic>, oHealth :Health, iIndex :Int ) {
		_oHealth = oHealth;
		super( oUnitVisual, iIndex );
		
		//_____
		_update();
		
		//Trigger
		_oHealth.onUpdate.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor

	override function _update() {
		
		_value_set( _oHealth.percent_get() );
	}
}