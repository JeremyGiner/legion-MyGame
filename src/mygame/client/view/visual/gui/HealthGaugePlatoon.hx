package mygame.client.view.visual.gui;

import js.three.*;
import mygame.game.ability.Platoon;
import trigger.*;

import mygame.client.model.GUI;
import mygame.client.view.visual.EntityVisual;
import mygame.client.view.visual.unit.UnitVisual;
//import mygame.client.view.GameView;
import mygame.game.ability.Health;

import trigger.*;

class HealthGaugePlatoon extends UnitGauge {
	
	var _oPlatoon :Platoon;
	
//______________________________________________________________________________
//	Constructor

	public function new( oUnitVisual :UnitVisual<Dynamic>, oPlatoon :Platoon, iIndex :Int ) {
		_oPlatoon = oPlatoon;
		super( oUnitVisual, iIndex );
		
		this.scale.setX( 5 );
		
		this.visible = false;
		_oGauge.visible = false;
		//_____
		_update();
		
		//Trigger
		untyped _oUnitVisual.unit_get().mygame_get().onHealthAnyUpdate.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor

	override function _update() {
		// Only draw once for the commander
		if ( _oPlatoon.commander_get() != _oUnitVisual.unit_get() )
			return;
		
		this.visible = true;
		_oGauge.visible = true;
		
		var fValue = _oPlatoon.subUnit_get().length / _oPlatoon.unitQuantityMax_get();
		//for ( oUnit in  )
			
		_value_set( fValue );
	}
}