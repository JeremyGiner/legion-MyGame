package mygame.client.view.visual.unit;

import js.three.*;
import mygame.game.ability.Loyalty;

import mygame.game.entity.Factory in Unit;
import mygame.client.view.GameView;
import mygame.client.view.visual.IEntityVisual;

import trigger.*;

class FactoryVisual extends UnitVisual<Unit> implements ITrigger {
	
	var _oMesh :Mesh;
	
	var _oBanner :Mesh;	// Player color apply on unit visual body
	
//______________________________________________________________________________
//	Constructor

	public function new( oDisplayer :GameView, oUnit :Unit ){
		
		super( oDisplayer, oUnit, 0.5);
		
		//_____
		
		_oMesh = new Mesh( 
			oDisplayer.geometry_get('factory'), 
			oDisplayer.material_get('factory')
		);
		_oMesh.scale.set( 0.5, 0.5, 0.5 );
		_oMesh.castShadow = true;
		_oScene.add( _oMesh );
		
		//_____
		
		// Player colors
		_oBanner = _playerColoredMesh_createAdd( _oMesh, true );
		
		//_____
		
		update();
		
		//_____
		
		

	}
	
//______________________________________________________________________________
//	Accessor

	public function entity_get(){ return _oUnit; }
	//public function unit_get() :Unit { return _oUnit; }
	
	//public function object3d_get() :Object3D { return _oMesh; }
	/*
	override public function update(){
		_oMesh.position.set(
			_oUnit.tile_get().x_get() * GameView.WORLDMAP_MESHSIZE*2,
			_oUnit.tile_get().y_get() * GameView.WORLDMAP_MESHSIZE*2,				
			_oUnit.tile_get().z_get() * GameView.WORLDMAP_MESHSIZE/4+0.7
		);
	}*/
	
	override function banner_update() {
		
		// Update player banner
		_oBanner.material = _oGameView.material_get_byPlayer( 'player_flat', unit_get().owner_get() );
	}
	
//______________________________________________________________________________
//	Sub-routine

	override function _clickBox_update() {
		super._clickBox_update();
		_oClickBox.max.z /= 2;
	}
	
//______________________________________________________________________________
//	Trigger

	override public function trigger( oSource :IEventDispatcher ) :Void { 
		
		super.trigger( oSource );
	
	}
	
}