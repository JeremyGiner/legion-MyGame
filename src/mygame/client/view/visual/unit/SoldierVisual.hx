package mygame.client.view.visual.unit;

import js.three.*;
import mygame.client.view.visual.unit.UnitVisual;
import mygame.game.entity.SubUnit;
import mygame.client.view.GameView;
import mygame.client.view.visual.IEntityVisual;
import mygame.game.ability.Mobility;
import mygame.game.ability.Volume;

class SoldierVisual extends SubUnitVisual<SubUnit> {
	
	var _oBody :Mesh;
	var _oSprite :Sprite;
	
//______________________________________________________________________________
//	Constructor

	public function new( oDisplayer :GameView, oUnit :SubUnit ){
		
		super( oDisplayer, oUnit, 2 );
	//_____
		_oBody = new Mesh( 
			oDisplayer.geometry_get( 'soldier' ), 
			_oGameView.material_get('wireframe')
		);
		_oScene.scale.set( 0.04, 0.04, 0.04 );
		
		//_oBody.scale.set( 1, 1, 1 );
		_oBody.rotation.set( 0, 0, -0.8);
		_oBody.castShadow = true;
		_oBody.visible = false;
		_oBody.updateMatrix();
		_oScene.add( _oBody );
		
		_oSprite = new Sprite( _oGameView.material_get_byPlayer( 'soldier', owner_get() ));
		_oSprite.scale.set( 2,2,2);
		_oSprite.position.set(0, 0, 0.5);
		_oScene.add( _oSprite );
		//Owner's color
		//_playerColoredMesh_createAdd( _oBody );
	
	//___
		
		
		update();
		
		_animationDeath_play();

	}
	
//______________________________________________________________________________
//	Accessor

	public function entity_get() { return _oUnit; }
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