package mygame.client.view.visual;

import js.three.*;
import trigger.*;


class GUIVisual implements IVisual implements ITrigger {
	private var _loMesh :List<Mesh>;
	private var _oGui :MyGUI;
	private var _oDisplayer :GameView;
	
//______________________________________________________________________________
//	Constructor

	public function new( oDisplayer :GameView, oGui :MyGUI ){
		_oDisplayer = oDisplayer;
		_oGui = oGui;
		
		_loMesh = new List<Mesh>();
		
		MyGUI.onUpdate.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor
	
	public function object3d_get() :Object3D { return _loMesh.first(); }

//______________________________________________________________________________
//	Utils

	public function update(){
	/*
		//Clear scene
		for( oObject3DTmp in _oScene.children )
			_oScene.remove( oObject3DTmp );
		
		//Create selection circle around each unit
		var oMeshTmp :Mesh;
		for( oUnit in _oGui.unitSelection_get() ){
			oMeshTmp = new Mesh( 
				new CircleGeometry(1,32), 
				_oDisplayer.material_get_tank()
			);
			oMeshTmp.scale.set( 8, 8, 8 );
			_oDisplayer.entityVisual_get_byEntity( oUnit ).object3d_get().add( oMeshTmp );
		}*/
	}
	
	public function trigger( oSource :IEventDispatcher ){
		update();
	}
}