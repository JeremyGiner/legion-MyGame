package mygame.client.view.visual.unit;

import js.three.Mesh;
import legion.ability.IAbility;
import mygame.client.view.visual.ability.WeaponVisual;
import mygame.client.view.visual.gui.HealthGaugePlatoon;
import mygame.game.ability.Weapon;
import mygame.game.entity.SubUnit;
import mygame.game.entity.Unit;

import mygame.game.ability.Health;
import mygame.game.ability.Guidance;
import mygame.game.ability.Platoon;

import mygame.client.view.visual.unit.UnitVisual;


class SubUnitVisual<CUnit:SubUnit> extends UnitVisual<CUnit> {

//______________________________________________________________________________
//	Constructor

	
//______________________________________________________________________________
//	Accessor


//______________________________________________________________________________
//	Modifier

	
//______________________________________________________________________________
//	Sub-routine

//_____________________________________
//	Ability related
	
	override function _abilityVisual_resolve( oAbility :IAbility ) :Array<VisualInfo> {
		
		switch( Type.getClass( oAbility ) ) {
			// No visual for following ability
			case Health :
				return [];
			case Platoon :
				return [
					{ 
						nodeName: 'gauge', 
						obj3d: new HealthGaugePlatoon( this, cast oAbility, _oGaugeHolder.children.length ) 
					}
				];
			case Weapon :
				var oAbilityW = cast(oAbility, Weapon);
				_oWeaponRange = new Mesh( 
					_oGameView.geometry_get('gui_selection_circle'), 
					_oGameView.material_get('wireframe_red')
				);
				
				_oWeaponRange.scale.set( 
					oAbilityW.rangeMax_get(), 
					oAbilityW.rangeMax_get(), 
					oAbilityW.rangeMax_get() 
				);
				_oWeaponRange.visible = false;
				return [
					{
						nodeName: 'root', 
						obj3d: _oWeaponRange
					},
					{
						nodeName: 'root', 
						obj3d: new WeaponVisual( this, cast oAbility )
					},
				];
		}
		
		// Else
		return super._abilityVisual_resolve( oAbility );
	}
	
}
