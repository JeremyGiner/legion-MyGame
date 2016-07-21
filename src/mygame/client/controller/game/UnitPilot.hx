package mygame.client.controller.game;

import js.Browser;
import mygame.client.view.visual.debug.Boxy;
import mygame.client.view.visual.entity.WorldMapVisual;
import mygame.game.ability.Platoon;
import space.Vector2i;
import trigger.*;


import legion.device.Mouse;
import legion.device.Keyboard;

import js.three.Vector3;
import space.Vector3 in Vector2;
import utils.three.Coordonate;

import mygame.game.MyGame in Game;
import mygame.game.tile.Tile;
import mygame.client.model.Model;
import mygame.client.view.GameView;
import mygame.client.view.visual.EntityVisual;
import mygame.client.view.visual.Marker;
import mygame.client.view.visual.debug.PathfinderVisual;
import mygame.client.view.visual.IVisual;

//import mygame.game.action.AbilityUse;
import mygame.game.ability.Mobility;
import mygame.game.ability.Guidance;
import mygame.game.ability.PositionPlan;
import mygame.game.ability.Position;

import mygame.game.action.UnitOrderMove;


//import mygame.ability.TiledMove in AbilityTiledMove;

class UnitPilot implements ITrigger {
	
	var _oGameView :GameView;
	var _oModel :Model;
	var _oGameController :GameController;
	
	var _oMouse :Mouse;
	var _oKeyboard :Keyboard;
	
	var _oMarker :Marker;
	
	// cache
	var _oDragDrop :Vector2i;

	// Debug
	//var _oPathfinderVisual :PathfinderVisual = null;
	
//______________________________________________________________________________
//	Constructor

	public function new( 
		oGameController :GameController, 
		oGameView :GameView, 
		oModel :Model,
		oMouse :Mouse,
		oKeyboard :Keyboard
	) {
		_oDragDrop = null;
		
		_oGameController = oGameController;
		_oModel = oModel;
		_oGameView = oGameView;
		_oMouse = oMouse;
		_oKeyboard = oKeyboard;
		
		_oMarker = new Marker();
		_oGameView.scene_get().add(_oMarker.object3d_get());
		
		// Trigger
		_oMouse.onPressRight.attach( this );
		_oMouse.onReleaseRight.attach( this );
		_oMouse.onMove.attach( this );
	}
	
//______________________________________________________________________________
//	

// OnRight click
		/*
		for( oUnit in _oUnitSelector ){
			
			if( building ){
				change rally point
				return
			}
			if( attacker )
				get click unit target
			if( movable )
				get click tile target
				//TODO : formation algorithme
				current player order unit use move ability on self
			
			
			
		}*/
	
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
	
	function vector_get( oMouse :Mouse ) {
		// Get worldmap ground mouse pointer
		var oVector = new Vector3();
		oVector = Coordonate.screen_to_worldGround( 
			oMouse.x_get(), 
			oMouse.y_get(), 
			_oGameView.renderer_get(), 
			_oGameView.camera_get()
		);
		_oGameView.scene_get().worldToLocal( oVector );
		
		// Get tile
		return new Vector2i( Math.round(oVector.x*10000), Math.round(oVector.y*10000) );
	}
	
	
	function unit_move( oVector :Vector2i, fAngle :Float ){
	
		
		//TODO : multiple unit at once ?
		
		// Get unit via unit selection
		var oSelect = _oModel.GUI_get().unitSelection_get();
		var oUnit = oSelect.unitList_get().first();
		if ( oUnit == null ) return;
		
		// Check if unit is ingame
		if ( oUnit.game_get() == null ) {
			oSelect.unit_remove( oUnit );	
			return;
		}
		
		// Check guidance
		if ( oUnit.ability_get(Guidance) == null && oUnit.ability_get(Platoon) == null )
			return;
		
		var oMovingAbility = oUnit.ability_get(Guidance) != null ? 
			oUnit.ability_get(Guidance) :
			oUnit.ability_get(Platoon);
		// POsition corection
		oVector = untyped oMovingAbility.positionCorrection( oVector );
			
		
		// Create action
		trace('Order unit to move!');
		/*var o = new Boxy(_oGameView);
		o.object3d_get().position.set(oVector.x, oVector.y, 5000);
		o.object3d_get().scale.set( 10000, 10000, 1 );*/
		
		_oGameController.action_add(
			new UnitOrderMove( 
				oUnit,
				oVector,
				fAngle,
				( _oKeyboard.keyState_get('Control') == true )
			)
		);
		
		// PathFind debug
		/*
		var oGuidance = oUnit.ability_get(Guidance);
		if ( PathfinderVisual.oInstance == null ) new PathfinderVisual( _oGameView, oGuidance.pathfinder_get() );
		else PathfinderVisual.oInstance.pathfinder_set( oGuidance.pathfinder_get() );*/
	}
	
	function test( oMouse :Mouse ){
		var oVector = new Vector3();
		oVector = Coordonate.screen_to_worldGround( 
			oMouse.x_get(), 
			oMouse.y_get(), 
			_oGameView.renderer_get(), 
			_oGameView.camera_get()
		);
		_oGameView.scene_get().worldToLocal( oVector );
		/*
		oVector.set(
			Std.int(oVector.x / 20 +0.5 )*20, 
			Std.int(oVector.y / 20 +0.5 )*20,
			1
		);*/
		_oMarker.move( oVector );
	}
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) {
		
		// Mouse right button
		if ( oSource == _oMouse.onPressRight ) {
			_oDragDrop = vector_get( cast oSource.event_get() );
			_oGameView.oArrowDirection.visible = true;
			_oGameView.oArrowDirection.position.set( 
				Position.metric_unit_to_map(_oDragDrop.x), 
				Position.metric_unit_to_map(_oDragDrop.y), 
				WorldMapVisual.LANDHEIGHT 
			);
			return;
		}
		if ( oSource == _oMouse.onReleaseRight ) {
			if ( _oDragDrop == null )
				return;
			
			var oVector = vector_get( cast oSource.event_get() );
			if ( oVector == null )
				return;
			
			// Get delta
			oVector.vector_add( _oDragDrop.clone().mult( -1 ) );
			
			unit_move( _oDragDrop, oVector.length_get() < 1000 ? 0 : oVector.angleAxisXY() );
			_oDragDrop = null;
			_oGameView.oArrowDirection.visible = false;
			return;
		}
		
		// Mouse cursor
		if ( oSource == _oMouse.onMove ) {
			test( cast oSource.event_get() );
			
			// Get selected unit
			var oSelect = _oModel.GUI_get().unitSelection_get();
			var oUnit = oSelect.unitList_get().first();
			if ( oUnit == null ) return;
			
			// Get positon plan
			var oPlan = oUnit.ability_get( PositionPlan );
			if ( oPlan == null ) return;
			
			// Change cursor
			var oVector = vector_get( _oMouse.onMove.event_get() );
			var oTile = _oModel.game_get().map_get().tile_get_byUnitMetric( oVector.x, oVector.y );
			if ( oPlan.validate(oTile) )
				Browser.document.body.style.cursor = 'default';
			else
				Browser.document.body.style.cursor = 'not-allowed';
			
			if ( _oDragDrop != null ) {
				oVector.vector_add( _oDragDrop.clone().mult( -1 ) );
				_oGameView.oArrowDirection.rotation.z = oVector.angleAxisXY();
			}
			return;
		}
	}
}