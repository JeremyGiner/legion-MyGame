package mygame.client.view.visual.unit;

import js.three.*;
import mygame.client.view.visual.unit.UnitVisual;
import mygame.game.ability.Volume;
//import mygame.game.entity.Unit.movable.Tank in Unit;
import mygame.game.entity.Tank in Unit;
import mygame.client.view.GameView;
import mygame.client.view.visual.IEntityVisual;

import mygame.game.ability.Weapon;
import mygame.game.ability.Mobility;

import Math;

class TankVisual extends UnitVisual<Unit> {
	
	var _oBody :Mesh;
	var _oTurret :Mesh;
	
//______________________________________________________________________________
//	Constructor

	public function new( oDisplayer :GameView, oUnit :Unit ) {
		
		// volume size ( in tile ) convert to main scene space
		var i = oUnit.ability_get(Volume).size_get() / 10000; 
		
		super( oDisplayer, oUnit, i );
		
		//_____
		
		var oMesh = new Object3D();
		oMesh.scale.set( i, i, i );
		
		_oScene.add( oMesh );
		
		//________________________
		// Setup body mesh
		
		_oBody = new Mesh( 
			oDisplayer.geometry_get( 'tank_body' ), 
			new MeshFaceMaterial([
				oDisplayer.material_get( 'tank' ),
				_oGameView.material_get_byPlayer( 'player_flat', unit_get().owner_get() )
			])
		);
		
		_oBody.castShadow = true;
		_oBody.renderOrder = 1;//didn't work
		//_oBody.renderDepth = 1;//didn't work
		oMesh.add( _oBody );
		
		//Owner's color
		//_playerColoredMesh_createAdd( _oBody );
		
		//________________________
		// Setup turret mesh
		
		_oTurret = new Mesh( 
			oDisplayer.geometry_get( 'tank_turret' ), 
			new MeshFaceMaterial([
				oDisplayer.material_get( 'tank' ),
				_oGameView.material_get_byPlayer( 'player_flat', unit_get().owner_get() )
			])
		);
		_oTurret.position.set(0,0,0.5);
		oMesh.add( _oTurret );
		
		//Owner's color
		//_playerColoredMesh_createAdd( _oTurret );
		
		
		update();

	}
	
//______________________________________________________________________________
//	Accessor

	public function entity_get(){ return _oUnit; }
	//public function unit_get() :Unit { return _oUnit; }
	
	//public function object3d_get() :Object3D { return _oBody; }
	
	override public function update() {
		super.update();
		
		
		//____________________
		// Mobility
		
		var oMobility = _oUnit.ability_get(Mobility);
		if( oMobility != null ) {
			_oBody.rotation.z = oMobility.orientation_get();
		}
		
		//____________________
		// Weapon
		
		var oWeapon = _oUnit.ability_get(Weapon);
		if(oWeapon.target_get() != null) {
			var oVisual = EntityVisual.get_byEntity( oWeapon.target_get() );
			if( oVisual != null ) {
				var targetPos = oVisual.object3d_get().localToWorld(
					new Vector3(0,0,0)
				);
				//targetPos = _oTurret.worldToLocal( targetPos );
				var myPos = object3d_get().localToWorld( new Vector3(0,0,0) );
				var v = new Vector3();
				v.subVectors( targetPos, myPos );
				var a = Math.atan2( v.y, v.x );	//Angle to X axis in XY plane
			
				_oTurret.rotation.z = a;
			}
		} else {
			_oTurret.rotation.z = _oBody.rotation.z;
		}
	}
	
	
	
	
	
}