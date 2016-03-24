package mygame.client.view.visual.debug;

import js.three.*;

import mygame.client.view.GameView;

class Boxy implements IVisual {
	var _oMesh :Mesh = null;
	var _oGameView :GameView;
	
	public static var oInstance :Boxy = null;
	
	public function new( oGameView :GameView ) {
		_oGameView = oGameView;
		
		_oMesh = new Mesh( 
			_oGameView.geometry_get( 'gui_guidancePreview' ),
			_oGameView.material_get( 'gui_guidancePreview' )
		);
		
		oInstance = this;
		
		_oGameView.scene_get().add( this.object3d_get() );
	}
	
	public function object3d_get() :Object3D { return _oMesh; }
}