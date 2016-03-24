package mygame.client.view.visual.unit;

import js.three.*;
import mygame.client.view.visual.unit.UnitVisual;
import mygame.game.entity.PlatoonUnit;
import mygame.client.view.GameView;
import mygame.client.view.visual.IEntityVisual;
import mygame.game.ability.Mobility;
import mygame.game.ability.Volume;
import mygame.game.ability.Platoon in PlatoonAbility;
import mygame.game.ability.Position;

class PlatoonVisual extends UnitVisual<PlatoonUnit> {
	
	var _oBody :Mesh;
//______________________________________________________________________________
//	Constructor

	public function new( oDisplayer :GameView, oUnit :PlatoonUnit ){
		
		super( oDisplayer, oUnit );
	//_____
		_oBody = new Mesh( 
			oDisplayer.geometry_get( 'city' ), 
			_oGameView.material_get_byPlayer( 'player', unit_get().owner_get() )
		);
		
		_oBody.scale.set( 0.3, 0.3, 0.3 );
		_oBody.rotation.set( 0, 0, -0.8);
		_oBody.castShadow = true;
		_oBody.updateMatrix();
		//_oScene.add( _oBody );
		
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
		// Position update
		var v = _subUnitPositionAvr_get();
		
		_oScene.position.setX( v.x );
		_oScene.position.setY( v.y );
		
		// trigger event
		onUpdateEnd.dispatch( this );
	}
//______________________________________________________________________________
//	Sub-routine

	/**
	 * @return average of SubUnits position
	 */
	function _subUnitPositionAvr_get() {
		var oPos = new Vector2();
		var aUnit = _oUnit.ability_get(PlatoonAbility).subUnit_get();
		for ( oUnit in aUnit ) {
			oPos.x += oUnit.ability_get(Position).x;
			oPos.y += oUnit.ability_get(Position).y;
		}
		oPos.divideScalar( aUnit.length );
		return oPos;
	}
}