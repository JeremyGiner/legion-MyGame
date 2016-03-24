package mygame.client.view.visual.unit;

import js.three.*;
import mygame.client.view.visual.unit.UnitVisual;
import mygame.game.entity.Soldier in Unit;
import mygame.client.view.GameView;
import mygame.client.view.visual.IEntityVisual;
import mygame.game.ability.Mobility;
import mygame.game.ability.Volume;

class CopterVisual extends UnitVisual<Unit> {
	
	var _oBody :Mesh;
	
	var _oHeightLine :Line;
	
	static var _oMaterial = { 
		new LineDashedMaterial( { color: 0xDEDEDE, dashSize: 3, gapSize: 1 } ); 
	};
	
//______________________________________________________________________________
//	Constructor

	public function new( oDisplayer :GameView, oUnit :Unit ){
		
		super( oDisplayer, oUnit );
	//_____
		var oMaterial = new MeshFaceMaterial(
			[
				_oGameView.material_get_byPlayer( 'player_flat', unit_get().owner_get() ),
				oDisplayer.material_get( 'copter' )
			]
		);
		_oBody = new Mesh( 
			oDisplayer.geometry_get( 'copter' ), 
			oMaterial
		);
		/*
		var oVolume = oUnit.ability_get(Volume);
		if( oVolume != null )
			_oBody.scale.set( oVolume.size_get(), oVolume.size_get(), oVolume.size_get() );
		else
			_oBody.scale.set( 0.2, 0.2, 0.2 );*/
		_oBody.scale.set( 0.166, 0.166, 0.166 );
		_oBody.rotation.set( 0, 0, -0.8);
		_oBody.castShadow = true;
		_oBody.updateMatrix();
		_oBody.position.setZ( 2 );
		_oScene.add( _oBody );
		
		//Height Line
		var geometry = new Geometry();
			
			geometry.vertices.push( 
				new Vector3( 0,0,0 )
			);
			geometry.vertices.push( 
				new Vector3( 0,0,2 )
			);
		_oHeightLine = new Line( geometry, _oMaterial );
		_oScene.add( _oHeightLine );
		//Owner's color
		//_playerColoredMesh_createAdd( _oBody );
	
	//___
		
		
		update();

	}
	
//______________________________________________________________________________
//	Accessor

	public function entity_get(){ return _oUnit; }
	//public function unit_get() :Unit { return _oUnit; }
	
	//public function object3d_get() :Object3D { return _oBody; };
	
//______________________________________________________________________________
//	Updater

	override public function update() {
		super.update();
	
		// Update mesh' orientation
		var oMobility = _oUnit.ability_get(Mobility);
		if( oMobility != null ) {
			_oBody.rotation.set( 0, 0, oMobility.orientation_get() );
		}
	}
//______________________________________________________________________________
//	Sub-routine
/*
	override function _decay_start() {
		super._decay_start();
		
		dispose();
	}
	
	override function dispose() {
		_oBody.parent.remove( _oBody ); _oBody = null;
	}*/
	
}