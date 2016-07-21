package mygame.client.view.visual.unit;

import js.three.*;
import mygame.client.view.visual.unit.UnitVisual;
import mygame.game.ability.Loyalty;
import mygame.game.ability.Position;
import mygame.game.entity.City in Unit;
import mygame.client.view.GameView;
import mygame.client.view.visual.IEntityVisual;
import trigger.*;

class CityVisual extends UnitVisual<Unit> implements ITrigger {
	
	var _oMesh :Mesh;
	
//______________________________________________________________________________
//	Constructor

	public function new( oDisplayer :GameView, oUnit :Unit ){
		
		super( oDisplayer, oUnit, 0.6);
		
		//_____
		var oMaterial = new MeshFaceMaterial(
			[
				oDisplayer.material_get( 'city' ),
				_oGameView.material_get_byPlayer( 'player_flat', _oEntity.ability_get(Loyalty).owner_get() )
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
		
		update();
		
		
		//_____

	}
	
//______________________________________________________________________________
//	Accessor

	public function entity_get() { return _oUnit; }
	
	override public function body_get() {
		return _oMesh;
	}
	
//______________________________________________________________________________
//	Update

	override public function update() {
		super.update();
	}
	
	override function _positionHeight_update( oPosition :Position ) {
		return;
	}
}