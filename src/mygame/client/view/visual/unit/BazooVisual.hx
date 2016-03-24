package mygame.client.view.visual.unit;

import js.three.*;
import mygame.client.view.visual.unit.UnitVisual;
import mygame.game.entity.Soldier in Unit;
import mygame.client.view.GameView;
import mygame.client.view.visual.IEntityVisual;
import mygame.game.ability.Mobility;
import mygame.game.ability.Volume;

class BazooVisual extends UnitVisual<Unit> {
	
	var _oBody :Mesh;
	
//______________________________________________________________________________
//	Constructor

	public function new( oDisplayer :GameView, oUnit :Unit ){
		
		super( oDisplayer, oUnit );
	//_____

		_oBody = new Mesh( 
			oDisplayer.geometry_get( 'bazoo' ), 
			new MeshFaceMaterial(
				[
					oDisplayer.material_get( 'soldier' ),
					_oGameView.material_get_byPlayer( 'player', unit_get().owner_get() )
				]
			)
		);
		var oVolume = oUnit.ability_get(Volume);
		if( oVolume != null )
			_oBody.scale.set( oVolume.size_get(), oVolume.size_get(), oVolume.size_get() );
		else
			_oBody.scale.set( 0.2, 0.2, 0.2 );
		//_oBody.scale.set( 1, 1, 1 );
		_oBody.rotation.set( 0, 0, -0.8);
		_oBody.castShadow = true;
		_oBody.updateMatrix();
		_oScene.add( _oBody );
		
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