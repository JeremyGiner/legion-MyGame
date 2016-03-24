package mygame.client.controller.game;

import js.three.Raycaster;
import mygame.client.view.visual.unit.UnitVisual;
import trigger.*;


import legion.device.Mouse;
import legion.device.Keyboard;

import js.three.Vector3;
import space.Vector3 in Vector2;
import utils.three.Coordonate;

import mygame.game.MyGame in Game;
import mygame.game.tile.Tile;
import mygame.game.entity.Unit;
import mygame.client.view.GameView;
import mygame.client.model.Model;
import mygame.client.view.visual.MapVisual;
import mygame.client.view.visual.EntityVisual;
import mygame.client.view.visual.Marker;
import mygame.client.view.visual.debug.PathfinderVisual;
import mygame.client.view.visual.IVisual;

import mygame.game.entity.SubUnit;

//import mygame.game.action.AbilityUse;
import mygame.game.ability.Position;
import mygame.game.ability.Mobility;
import mygame.game.ability.Guidance;

import mygame.game.action.UnitOrderMove;


//import mygame.ability.TiledMove in AbilityTiledMove;

class UnitSelection implements ITrigger {
	
	var _oGameView :GameView;
	var _oGameController :GameController;
	var _oModel :Model;
	
	var _oMouse :Mouse;
	
//______________________________________________________________________________
//	Constructor

	public function new( 
		oGameController :GameController, 
		oGameView :GameView,
		oModel :Model,
		oMouse :Mouse,
		oKeyboard :Keyboard
	){
		_oGameController = oGameController;
		_oGameView = oGameView;
		_oModel = oModel;
		
		//
		_oMouse = oMouse;
		_oMouse.onPressRight.attach( this );
		_oMouse.onPressLeft.attach( this );
		//_oMouse.onMove.attach( this );
	}
	
//_____________________________________________________________________________

	

	function tile_get( oMouse :Mouse ){
		
		// Get worldmap ground mouse pointer
		var oVector = new Vector3();
		oVector = Coordonate.screen_to_worldGround( 
			oMouse.x_get(), 
			oMouse.y_get(), 
			_oGameView.renderer_get(), 
			_oGameView.camera_get()
		);
		_oGameView.scene_get().worldToLocal( oVector );
		
		// Get map visual
		var oMapVisual :MapVisual = cast EntityVisual.get_byEntity( _oGameController.game_get().map_get() );
		
		// Get tile
		return oMapVisual.tile_get_byVector( oVector );
	}
	
	/*
	static public function unitVisual_get( 
		x :Int, y :Int, 
		oGameView :GameView 
	) :UnitVisual<Dynamic> {
		
		// Transform mouse coordonate
		var oVector = Coordonate.canva_to_eye( 
			x, y,
			oGameView.renderer_get() 
		);
		
		// Get raycaster
		var oRaycaster = new Raycaster();
		oRaycaster.setFromCamera( oVector, oGameView.camera_get() );
		
		// Get first unit visual with a clickbbox that intersect with ray
		for ( oUnitVisual in oGameView.unitVisual_get_all() ) {
			var oGeometry = oUnitVisual.clickBox_get();
			
			if ( oGeometry == null )
				continue;
			
			var aIntersect = oRaycaster.ray.intersectBox( oGeometry );
			if ( aIntersect != null )
				return oUnitVisual;
		}
		return null;
	}*/
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ){
		
		// Mouse Right button
		if( oSource == _oMouse.onPressLeft ){
		
			var oMouse :Mouse = cast oSource.event_get();
			
			// Get unit visual under the mouse
			var oUnitVisual = UnitVisual.get_byRaycasting( 
				oMouse.x_get(), oMouse.y_get(), 
				_oGameView 
			);
			
			if ( oUnitVisual == null )
				return;
			
			// Get unit
			var oUnit = oUnitVisual.unit_get();
			
			if ( oUnit == null ) 
				return;
			
			// Case subunit
			if ( Std.is( oUnit, SubUnit ) ) {
				// Select platoon instead
				oUnit = cast( oUnit, SubUnit ).platoon_get();
			}
			
			// Add unit
			var oUnitSelection = _oModel.GUI_get().unitSelection_get();
			oUnitSelection.remove_all();
			oUnitSelection.unit_add( oUnit );
		}
	}
}