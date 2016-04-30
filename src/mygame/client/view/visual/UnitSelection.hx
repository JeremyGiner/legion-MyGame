package mygame.client.view.visual;

import js.three.*;
import mygame.client.model.Model;
import mygame.game.ability.Mobility;
import mygame.game.ability.Platoon;
import space.Vector2i;

import mygame.game.ability.Guidance;
import mygame.game.ability.Volume;
import mygame.game.ability.Position;
import mygame.client.view.GameView;
import mygame.client.model.UnitSelection in UnitSelectionModel;
import mygame.client.controller.game.UnitSelection in UnitSelectionController;
import utils.three.Coordonate;
import trigger.*;

import space.Vector3 in Vector;

import mygame.client.view.visual.unit.UnitVisual;

import Math;

class UnitSelection implements IVisual implements ITrigger {
	
	var _oGameView :GameView;
	
	var _oModel :Model;
	var _oSelection :UnitSelectionModel;
	var _loVisual :List<UnitVisual<Dynamic>>;
	
	var _oGuidancePreview :Object3D;
	var _oGuidancePreviewLine :Line;
	
	var _oUnitVisualSelectionPreview :UnitVisual<Dynamic>;
	
	var _bUpdateNeeded :Bool;
	
//______________________________________________________________________________
//	Constructor
		
	public function new( oGameView :GameView, oModel :Model ){
		_oGameView = oGameView;
		_oModel = oModel;
		
		
		//_____
		
		_oSelection = oModel.GUI_get().unitSelection_get();
		
		_loVisual = new List<UnitVisual<Dynamic>>();
		
		// Assume game entity visual already loaded
		_update_circle();
		
		_oUnitVisualSelectionPreview = null;
		//_____
		_bUpdateNeeded = false;
		
		_oGuidancePreview = new Mesh(
			_oGameView.geometry_get( 'gui_guidancePreview' ),
			_oGameView.material_get( 'gui_guidancePreview' )
		);
		
		_oGuidancePreview.position.set( 0, 0, 0 );
		_oGuidancePreview.receiveShadow = true;
		_oGuidancePreview.visible = false;
		oGameView.scene_get().add( _oGuidancePreview );
		
		var oGeometry = new Geometry();
		oGeometry.vertices.push( new Vector3(0, 0, 0) );
		oGeometry.vertices.push( new Vector3(-10, -10, 0) );
		_oGuidancePreviewLine = new Line(
			oGeometry,
			untyped _oGameView.material_get( 'gui_guidancePreviewLine' ) //untyped _oGameView.material_get( 'gui_guidancePreview' )
		);
		oGameView.scene_get().add( _oGuidancePreviewLine );
		
		//_____
		// Trigger
		
		_oSelection.onUpdate.attach( this );
		_oModel.mouse_get().onMove.attach( this );
		_oModel.game_get().onLoopEnd.attach( this );
		_oGameView.onFrame.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor

	public function object3d_get() :Object3D { return null; }

//______________________________________________________________________________
//	Updater
	
	function _update_circle() {
	
		// Cleaning previous
		for ( oVisual in _loVisual ) {
			if ( oVisual.gameView_get() != null ) {	//Check if not already disposed
				oVisual.selection_set(false);
				oVisual.rangeVisualVisibility_set( false );
			}
		}
		_loVisual.clear();
		
		// Update each visual
		var oSelection = _oSelection.unitSelection_get();
		for( sUnitType in oSelection.keys() ) {
			for ( oUnit in oSelection.get(sUnitType) ) {
				
				var oVisual :UnitVisual<Dynamic> = cast EntityVisual.get_byEntity( oUnit );
				oVisual.selection_set(true);
				oVisual.rangeVisualVisibility_set( true );
				_loVisual.add( oVisual );
				
				// Case : platoon
				var oPlatoon = oUnit.ability_get(Platoon);
				if ( oPlatoon != null ) {
					for ( oSubUnit in oPlatoon.subUnit_get() ) {
						var oVisual :UnitVisual<Dynamic> = cast EntityVisual.get_byEntity( oSubUnit );
						oVisual.selection_set(true);
						oVisual.rangeVisualVisibility_set( true );
						_loVisual.add( oVisual );
					}
				}
				
			}
		}
		
	}
	
	function _destinationPreview_update() {
		
		if ( !_bUpdateNeeded )
			return;
		
		// Get unit via unit selection
		var oSelect = _oModel.GUI_get().unitSelection_get();
		var oUnit = oSelect.unitList_get().first();
		if ( oUnit == null ) 
			return;
		
		// Get guidance
		var oGuidance = oUnit.ability_get(Guidance);
		if ( oGuidance == null ) {
			_oGuidancePreview.visible = false;
			_oGuidancePreviewLine.visible = false;
			return;
		}
		
		var oVector :Dynamic;
		oVector = Coordonate.screen_to_worldGround( 
			_oModel.mouse_get().x_get(), 
			_oModel.mouse_get().y_get(), 
			_oGameView.renderer_get(), 
			_oGameView.camera_get()
		);
		
		// World coordonate to unbit coordonate
		oVector = new Vector2i( 
			Math.round( oVector.x * 10000 ), 
			Math.round( oVector.y * 10000 ) 
		);
		
		oVector = oGuidance.positionCorrection( oVector );
		oVector = Position.metric_unit_to_map_vector( oVector );
		
		// Update volume preview
		var oVolume = oUnit.ability_get( Volume );
		if ( oVolume != null ) {
			var i = Position.metric_unit_to_map( oVolume.size_get() );
			_oGuidancePreview.position.set( oVector.x, oVector.y, 0.25 );
			_oGuidancePreview.scale.set( i, i, i );
		}
		
		var oPlatoon = oUnit.ability_get(Platoon);
		if ( oPlatoon != null ) {
			var i = Position.metric_unit_to_map( oPlatoon.halfSize_get() );
			_oGuidancePreview.position.set( oVector.x, oVector.y, 0.25 );
			_oGuidancePreview.scale.set( i, i, i );
		}
		
			
		if ( oVector == null )
			return;
		
		// Update GuidancePreviewLine geometry
		var oVisual = EntityVisual.get_byEntity( oUnit );
		var oPosition = oVisual.object3d_get().position;
		
		var scene = _oGuidancePreviewLine.parent;
		scene.remove(_oGuidancePreviewLine);
		var oGeometry = new Geometry();
		oGeometry.vertices.push( new Vector3(oVector.x, oVector.y, 0.25) );
		oGeometry.vertices.push( 
			new Vector3(
				oPosition.x, 
				oPosition.y, 
				0.5
			) 
		);
		_oGuidancePreviewLine = new Line(
			oGeometry,
			untyped _oGameView.material_get( 'gui_guidancePreviewLine' )
		);
		//_oLine = new Line( geometry, _oMaterial, Three.LinePieces );
		scene.add(_oGuidancePreviewLine);
		
		_oGuidancePreview.visible = true;
		_oGuidancePreviewLine.visible = true;
	}
	
//______________________________________________________________________________
//	Trigger
	
	public function trigger( oSource :IEventDispatcher ) {
		if( oSource == _oSelection.onUpdate ) {
			_update_circle();
		}
		
		if ( 
			oSource == _oModel.game_get().onLoopEnd || 
			oSource == _oModel.mouse_get().onMove 
		) {
			_bUpdateNeeded = true;
		}
		
		if ( oSource == _oGameView.onFrame ) {
			_destinationPreview_update();
		}
	}
}
