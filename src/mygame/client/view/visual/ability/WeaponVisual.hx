package mygame.client.view.visual.ability;

import js.three.*;
import mygame.client.view.GameView;
import mygame.client.view.visual.ability.UnitAbiltiyVisual.UnitAbilityVisual;
import trigger.*;
import utils.IDisposable;

import mygame.client.model.GUI;
import mygame.client.view.visual.unit.UnitVisual;
import mygame.game.ability.Weapon;
//import mygame.client.view.GameView;

import mygame.client.view.visual.EntityVisual;

import Math;

class WeaponVisual extends Object3D implements ITrigger implements IDisposable {
	
	var _oUnitVisual :UnitVisual<Dynamic>;
	
	var _oAbility :Weapon;
	var _oLine :Line = null;
	var _oGameView :GameView;
	
//_____
	
	static var _oMaterial = { 
		new LineBasicMaterial({ color: 0xFFFF00 }); 
	};
	
//______________________________________________________________________________
//	Constructor

	public function new( 
		oUnitVisual :UnitVisual<Dynamic>, 
		oWeapon :Weapon
	) {
		super();
		_oUnitVisual = oUnitVisual;
		_oGameView = _oUnitVisual.gameView_get();
		_oAbility = oWeapon;
		
		//_____
		
		// Trigger
		_oAbility.unit_get().mygame_get().onLoopEnd.attach(this);
		_oAbility.unit_get().onDispose.attach( this );
		_oAbility.onFire.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor
	
	public function update() {
		if ( parent == null ) {
			trace('notice : disposed ');
			dispose();
		}
		
		if ( _oLine == null )
			return;
			
		// Fade
		if ( _oAbility.cooldown_get().expirePercent_get() > 0.5 ) {
			
			// Dispose of line
			_fireLine_dispose();
		}
	}
	
	public function disposed_check() {
		return true;
	}
	
//______________________________________________________________________________
//	Sub-routine

	function _fireLine_create() {
		//Clean previous line
		if ( _oLine != null ) {
			_fireLine_dispose();
		}
		
		// Useless check
		if ( _oAbility.target_get() == null ) 
			throw('something is wrong');
		
		// Create fire line
		var oTargetVisual = EntityVisual.get_byEntity( _oAbility.target_get() );
		if ( oTargetVisual == null )
			throw('something is wrong');
		var geometry = new Geometry();
		geometry.vertices.push( _oUnitVisual.object3d_get().localToWorld( new Vector3(0, 0.1, 0) ) );
		geometry.vertices.push( oTargetVisual.object3d_get().localToWorld( new Vector3(0,0.1,0) ) );
		_oLine = new Line( geometry, _oMaterial );
		
		_oUnitVisual.gameView_get().scene_get().add( _oLine );
	}
	
	function _fireLine_dispose() {
		if ( _oLine == null )
			return;
		
		// Dispose of line
		_oLine.parent.remove( _oLine );
		_oLine = null;
	}

//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		if ( oSource == _oAbility.onFire ) {
			_fireLine_create();
			return;
		}
		if ( oSource == _oAbility.unit_get().onDispose ) {
			dispose();
			return;
		}
		if ( oSource == _oAbility.unit_get().mygame_get().onLoopEnd ) {
			update();
			return;
		}
		
	}
//______________________________________________________________________________
//	Disposer

	public function dispose() {
		_fireLine_dispose();
		
		// Remove from event dispatcher
		_oAbility.unit_get().mygame_get().onLoopEnd.remove(this);
		
	}
}