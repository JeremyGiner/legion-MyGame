package mygame.client.view.visual.ability;

import js.three.*;
import mygame.client.view.GameView;
import mygame.client.view.visual.ability.UnitAbiltiyVisual.UnitAbilityVisual;
import trigger.*;

import mygame.client.model.GUI;
import mygame.client.view.visual.unit.UnitVisual;
import mygame.game.ability.Weapon;
//import mygame.client.view.GameView;

import mygame.client.view.visual.EntityVisual;

import Math;

class WeaponVisual extends UnitAbilityVisual<Weapon> implements IVisual implements ITrigger {
	
	var _oUnitVisual :UnitVisual<Dynamic>;
	var _oGUI :GUI;
	
	var _oSprite :Sprite;
	var _oLine :Line = null;
	var _oGameView :GameView;
	
//_____

	static var _oMatBackground :SpriteMaterial = { 
		new SpriteMaterial({color:0x000000,depthTest:false,depthWrite:false});
	};
	static var _oMatForeground :SpriteMaterial = { 
		new SpriteMaterial({color:0xff5555,depthTest:false,depthWrite:false});
	};
	
	static var _oMaterial = { 
		new LineBasicMaterial({ color: 0xFF0000 }); 
	};
	
	static var _fBorderSize = 3;
	
//______________________________________________________________________________
//	Constructor

	public function new( 
		oUnitVisual :UnitVisual<Dynamic>, 
		oWeapon :Weapon, 
		oGUI :GUI 
	) {
		super( oWeapon );
	//public function new( oEntity :IWeapony ){
		_oUnitVisual = oUnitVisual;
		_oGameView = _oUnitVisual.gameView_get();
		_oAbility = oWeapon;
		_oGUI = oGUI;
		
		//_____
		
/*
		// Foreground
		_oSprite = new Sprite( _oMatForeground );
		_oSprite.scale.set( 20, 5, 1 );
		_oScene.add( _oSprite );
		
		// Background
		var oSpriteTmp :Sprite = new Sprite( _oMatBackground );
		oSpriteTmp.scale.set( 20+_fBorderSize, 5+_fBorderSize, 1 );
		oSpriteTmp.position.set( 0, 0, 0 );
		_oSprite.add( oSpriteTmp );

		_oUnitVisual.gameView_get().sceneOrtho_get().add(_oScene);*/
		
		//---
		update();
		
		
		// Trigger
		//_oGUI.onModeChange.attach( this );
		//oGameView.onFrame.attach( this );
		_oGameView.model_get().game_get().oWeaponProcess.onTargeting.attach(this);
		_oAbility.onFire.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor
	
	public function update() {
		
		// New target
		if( _oAbility.target_get() != null && _oLine == null ) {
			var oTargetVisual :EntityVisual<Dynamic> = EntityVisual.get_byEntity( _oAbility.target_get() );
			if( oTargetVisual != null ) {
			
				var geometry = new Geometry();
				geometry.vertices.push( new Vector3( 0, 0.1, 0 ) );
				geometry.vertices.push( new Vector3( 0, 0, 0 ) );
				
				//var oMaterial = _oUnitVisual.gameView_get().material_get_byPlayer(_oUnitVisual.unit_get().owner_get() );
				_oLine = new Line( geometry,  _oMaterial );
				
				// Add to the scene
				_oUnitVisual.object3d_get().add( _oLine );
			}
		} else
		// Lost target
		if( _oAbility.target_get() == null && _oLine != null ) {
			_oUnitVisual.object3d_get().remove( _oLine );
			_oLine = null;
		}
		
		// Update target position
		if( _oLine != null ) {
			var oTargetVisual :EntityVisual<Dynamic> = EntityVisual.get_byEntity( _oAbility.target_get() );
			var v = _oUnitVisual.object3d_get().worldToLocal( 
						oTargetVisual.object3d_get().localToWorld( new Vector3(0,0,0) )
					);
			untyped _oLine.geometry.verticesNeedUpdate = true;
			untyped _oLine.geometry.vertices[1] = v;
			_oLine.updateMatrix();
			
			// Fade test
			if ( _oAbility.cooldown_get().expirePercent_get() > 0.5 )
				_oLine.visible = false;
		}
		
		
		/*
		var vector = new Vector3( 0, 0, 0);
		var mat = new Matrix4();

		_oUnitVisual.object3d_get().updateMatrix();
		_oUnitVisual.object3d_get().updateMatrixWorld();
		
		_oUnitVisual.object3d_get().localToWorld( vector );
		
		vector.applyMatrix4( mat.getInverse( untyped _oUnitVisual.gameView_get().camera_get().matrixWorld )  );
		vector.applyProjection( cast _oUnitVisual.gameView_get().camera_get().projectionMatrix );
		
		//mat.getInverse( _oUnitVisual.gameView_get().cameraOrtho_get().projectionMatrix );
		//vector.applyMatrix4( mat );
		
		//_oUnitVisual.gameView_get().cameraOrtho_get().localToWorld(vector);
		//_oUnitVisual.gameView_get().sceneOrtho_get().worldToLocal(vector);
		
		vector.applyMatrix4( mat.getInverse( _oUnitVisual.gameView_get().cameraOrtho_get().projectionMatrix) );
		
		_oSprite.position.copy(vector);
		_oSprite.position.y -= 10;
		_oSprite.position.setZ(5);*/
	}
	
	public function update_visibility() {
		if( _oGUI.mode_get() == 0 )
			hide();
		else
			show();
	}
	
//______________________________________________________________________________
//	Sub
	
	function hide() {
		trace( untyped _oSprite.material.visible );
		_oMatBackground.visible = false;
		_oMatForeground.visible = false; 
	}
	function show() { 
		trace( untyped _oSprite.material.visible );
		_oMatBackground.visible = true; 
		_oMatForeground.visible = true; 
	}

//______________________________________________________________________________
//	Trigger

	override public function trigger( oSource :IEventDispatcher ) :Void { 
		
		if ( oSource == _oGameView.model_get().game_get().oWeaponProcess.onTargeting ) {
			update();
		}
		
		if ( oSource == _oAbility.onFire ) {
			
			// Make line appear
			if( _oLine != null )
				_oLine.visible = true;
		}
		
		super.trigger( oSource );
	}
//______________________________________________________________________________
//	Disposer

	override public function dispose() {
		// Remove from event dispatcher
		_oGameView.model_get().game_get().oWeaponProcess.onTargeting.remove(this);
		
		//___
		super.dispose();
	}
}