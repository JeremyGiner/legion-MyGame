package mygame.client.view.visual.gui;

import js.three.*;
import mygame.game.ability.Deploy;
import mygame.game.ability.Weapon;
import trigger.*;

import mygame.client.model.GUI;
import mygame.client.view.visual.EntityVisual;
import mygame.client.view.visual.unit.UnitVisual;
//import mygame.client.view.GameView;

import Math;


class DeployGauge extends UnitGauge implements ITrigger {
	
	var _oDeploy :Deploy;
	
//______________________________________________________________________________
//	Constructor

	public function new( oUnitVisual :UnitVisual<Dynamic>, oDeploy :Deploy, iIndex ) {
		super( oUnitVisual, iIndex, 'hud_gauge_red' );
		_oDeploy = oDeploy;
		
	}

//______________________________________________________________________________
//	Sub-routine

	override function _update() {
		
		var fValue = Math.min( 
			1, 
			_oDeploy.percent_get() 
		);
		
		_value_set( fValue );
	}
	


	
}