package mygame.client.view.visual.ability;

import js.three.*;
import mygame.game.ability.UnitAbility;
import trigger.*;
import utils.Disposer;

import mygame.client.model.GUI;
import mygame.client.view.visual.unit.UnitVisual;
import mygame.game.ability.Weapon;
//import mygame.client.view.GameView;

import mygame.client.view.visual.EntityVisual;

class UnitAbilityVisual<CAbility:UnitAbility> implements IVisual implements ITrigger {
	
	var _oOrigin :Object3D;
	var _oAbility :CAbility;
	//var _oUnitVisual :UnitVisual<Dynamic>;
	var _bDisposed :Bool = false;
	
//______________________________________________________________________________
//	Constructor

	public function new( oAbility :CAbility ) {
		_oAbility = oAbility;
		
		//_____
		
		_oOrigin = new Object3D();

		// Trigger
		_oAbility.onDispose.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor
	
	public function object3d_get() :Object3D { return _oOrigin; }

//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 

		if( oSource == _oAbility.onDispose ) {
			dispose();
		}
	}
//______________________________________________________________________________
//	Disposer
	
	public function dispose() {
		
		// Dispose of origin
		if( _oOrigin.parent != null )
			_oOrigin.parent.remove( _oOrigin );
		//TODO : dispose of origin'children
		
		// Wipe all
		Disposer.dispose( this );
		
		_bDisposed = true;
	}
}