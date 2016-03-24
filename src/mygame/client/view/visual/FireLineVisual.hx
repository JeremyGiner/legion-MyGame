package mygame.client.view.visual;

import js.three.*;
import mygame.client.view.visual.UnitVisual;
import mygame.client.view.GameView;
import mygame.client.view.visual.IEntityVisual;

class FireLineVisual extends UnitVisual<Unit> {
	/*private var _oMesh :Mesh;
	private var _oUnit :Unit;
	private var _oDisplayer :GameView;*/
	
	private var _oLine :Line = null;
	
	private var _oWeapon :Weapon;
	
//______________________________________________________________________________
//	Constructor

	public function new( oWeapon :Weapon ){
		//_____
		
		_oWeapon = oWeapon;
		
		var material = new LineBasicMaterial({ color: 0xff00ff });
		var geometry = new Geometry();
		
		geometry.vertices.push( new Vector3( i*2-0.2, j*2-0.2, 0 ) );
		geometry.vertices.push( new Vector3( i*2+0.2, j*2+0.2, 0 ) );
					
		_oLine = new Line( geometry, material );
		
		update();

	}
	
//______________________________________________________________________________
//	Accessor
	
	public function object3d_get() :Object3D { return _oLine; }
	
	override public function update(){
		_oLine.
	}
	
}