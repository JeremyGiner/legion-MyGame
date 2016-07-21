package mygame.client.view.visual.unit;

import js.three.*;
import mygame.client.view.visual.unit.UnitVisual;
import mygame.game.entity.Bazoo;
import mygame.game.entity.Bazoo in Unit;
import mygame.client.view.GameView;
import mygame.client.view.visual.IEntityVisual;
import mygame.game.ability.Mobility;
import mygame.game.ability.Volume;
import mygame.game.ability.Loyalty;

class BazooVisual extends SubUnitVisual<Bazoo> {
	
	var _oBody :Mesh;
	
//______________________________________________________________________________
//	Constructor

	public function new( oDisplayer :GameView, oUnit :Unit ){
		
		super( oDisplayer, oUnit, 2 );
	//_____

		_oBody = new Mesh( 
			oDisplayer.geometry_get( 'bazoo' ), 
			new MeshFaceMaterial(
				[
					oDisplayer.material_get( 'wireframe' ),
					_oGameView.material_get_byPlayer( 'player', owner_get() )
				]
			)
		);
		_oScene.scale.set( 0.04, 0.04, 0.04 );
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
	override public function body_get() {
		return _oBody;
	}
	
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

	override function _clickBox_update() {
		_oClickBox = new Box3();
		_oClickBox.setFromObject( _oBody );
	}
	
}