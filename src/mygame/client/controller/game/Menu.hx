package mygame.client.controller.game;

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

//import mygame.game.action.AbilityUse;
import mygame.game.ability.Position;
import mygame.game.ability.Mobility;
import mygame.game.ability.Guidance;

import mygame.game.action.UnitOrderBuy;

import trigger.eventdispatcher.EventDispatcherJS;
import js.html.MouseEvent;
import js.html.ButtonElement;

//import mygame.ability.TiledMove in AbilityTiledMove;

class Menu implements ITrigger {
	
	var _oGameView :GameView;
	var _oGameController :GameController;
	var _oModel :Model;
	
//______________________________________________________________________________
//	Constructor

	public function new( 
		oGameController :GameController, 
		oGameView :GameView,
		oModel :Model
	){
		_oGameController = oGameController;
		_oGameView = oGameView;
		_oModel = oModel;
		
		EventDispatcherJS.onClick.attach( this );	//TODO : reduce capture range
	}
	
//______________________________________________________________________________
//	
	
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ){
	
		if( oSource == EventDispatcherJS.onClick ){
			
			//TODO : clean up this code
			// ? add unit id in dataset 
			
			//trace( oSource.event_get() );
			var oEvent = cast(oSource.event_get(),MouseEvent);
			if( !Std.is(oEvent.target,ButtonElement) ) return;
			var oButton = cast(oEvent.target,ButtonElement);
			if( Reflect.hasField( oButton.dataset, 'sale' ) ) {
				_oGameController.action_add(
					new UnitOrderBuy(
						_oModel.GUI_get().unitSelection_get().unitList_get().first(),
						Std.parseInt( untyped oButton.dataset.sale )
					)
				);
			}
		}
	}
}