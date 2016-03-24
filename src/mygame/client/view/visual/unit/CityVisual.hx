package mygame.client.view.visual.unit;

import js.three.*;
import mygame.client.view.visual.unit.UnitVisual;
import mygame.game.entity.City in Unit;
import mygame.client.view.GameView;
import mygame.client.view.visual.IEntityVisual;
import trigger.*;

class CityVisual extends UnitVisual<Unit> implements ITrigger {
	
	var _oMesh :Mesh;
	
	var _oBanner :Mesh;	// Player color apply on unit visual body
	
//______________________________________________________________________________
//	Constructor

	public function new( oDisplayer :GameView, oUnit :Unit ){
		
		super( oDisplayer, oUnit, 0.5);
		
		//_____
		var oMaterial = new MeshFaceMaterial(
			[
				oDisplayer.material_get( 'city' ),
				_oGameView.material_get_byPlayer( 'player_flat', unit_get().owner_get() )
			]
		);
		_oMesh = new Mesh( 
			oDisplayer.geometry_get( 'city' ), 
			oMaterial
		);
		_oMesh.scale.set( 0.5, 0.5, 0.5 );
		_oMesh.castShadow = true;
		_oScene.add( _oMesh );
		
		//_____
		
		// Player colors
		//_oBanner = _playerColoredMesh_createAdd( _oMesh, true );
		
		//_____
		
		update();
		_position_update();
		
		
		//_____
		
		unit_get().onUpdate.attach( this );

	}
	
//______________________________________________________________________________
//	Accessor

	public function entity_get(){ return _oUnit; }
	//public function unit_get() :Unit { return _oUnit; }
	
	//public function object3d_get() :Object3D { return _oMesh; }
	
	function banner_update() {
		
		// Update player banner
		//_oBanner.material = _oGameView.material_get_byPlayer( 'player_flat', unit_get().owner_get() );
		cast(_oMesh.material,MeshFaceMaterial).materials[1] = _oGameView.material_get_byPlayer( 'player_flat', unit_get().owner_get() );
	}
	
//______________________________________________________________________________
//	Update

	override public function update() {
		return;
	}
	
//______________________________________________________________________________
//	Trigger

	override public function trigger( oSource :IEventDispatcher ) :Void { 
		super.trigger( oSource );
		
		// On city update
		if( oSource == unit_get().onUpdate )
			banner_update();
	
	}
	
}