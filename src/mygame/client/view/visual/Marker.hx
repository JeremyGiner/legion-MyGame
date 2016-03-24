package mygame.client.view.visual;

import js.three.*;
import js.html.DivElement;

import mygame.client.view.GameView;

class Marker implements IVisual {
	private var _oMesh :Mesh;
	
	var _oDiv :DivElement;
	
	public function new() {
		_oMesh = new Mesh( 
			new CircleGeometry( 1, 32 ), 
			new MeshBasicMaterial(
				{ color: 0xFF5555, wireframe: false, opacity: 0.5, transparent: true }
			) 
		);
		_oMesh.scale.set( 0.5, 0.5, 0.5 );
		_oMesh.position.set( 0, 0, 0 );
		_oMesh.castShadow = true;
		_oMesh.receiveShadow = true;
		
		_oDiv = cast js.Browser.document.getElementById('MouseXY');
	}
	
	
	public function move( oVector :Vector3 ) {
		_oMesh.position.setX( oVector.x );
		_oMesh.position.setY( oVector.y );
		_oMesh.position.setZ( oVector.z );
		
		// test
		var v = _oMesh.localToWorld(new Vector3(0,0,0));
		_oDiv.innerHTML = '['+v.x+';'+v.y+']';
	}
	
	public function update(){}
	
	public function object3d_get() :Object3D { return _oMesh; }
}