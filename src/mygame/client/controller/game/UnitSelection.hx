package mygame.client.controller.game;

import js.three.Raycaster;
import mygame.client.view.visual.entity.WorldMapVisual;
import mygame.client.view.visual.unit.UnitVisual;
import mygame.game.ability.Platoon;
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
		var oMapVisual :WorldMapVisual = cast EntityVisual.get_byEntity( _oGameController.game_get().map_get() );
		
		// Get tile
		return oMapVisual.tile_get_byVector( oVector );
	}
	
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
			
			//
			var oUnitSelection = _oModel.GUI_get().unitSelection_get();
			oUnitSelection.remove_all();
			
			// Case platoon
			if ( oUnit.ability_get(Platoon) != null ) {
				// Select platoon instead
				for ( oUnit in oUnit.ability_get(Platoon).subUnit_get() ) {
					oUnitSelection.unit_add( oUnit );
				}
				return;
			}
			
			// Add unit
			oUnitSelection.unit_add( cast oUnit );
		}
	}
}