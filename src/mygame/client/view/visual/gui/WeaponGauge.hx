package mygame.client.view.visual.gui;

import js.three.*;
import mygame.game.ability.Weapon;
import trigger.*;

import mygame.client.model.GUI;
import mygame.client.view.visual.EntityVisual;
import mygame.client.view.visual.unit.UnitVisual;
//import mygame.client.view.GameView;

import Math;


class WeaponGauge extends UnitGauge implements ITrigger {
	
	var _oWeapon :Weapon;
	
//______________________________________________________________________________
//	Constructor

	public function new( oUnitVisual :UnitVisual<Dynamic>, oWeapon :Weapon, iIndex ) {
		super( oUnitVisual, iIndex, 'hud_gauge_red' );
		_oWeapon = oWeapon;
		
	}

//______________________________________________________________________________
//	Sub-routine

	override function _update() {
		
		var fValue = Math.min( 
			1, 
			_oWeapon.cooldown_get().expirePercent_get() 
		);
		
		_value_set( fValue );
	}
	


	
}