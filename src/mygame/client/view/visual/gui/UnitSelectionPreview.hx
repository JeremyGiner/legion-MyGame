package mygame.client.view.visual.gui;

import js.three.*;
import mygame.client.model.Model;

import mygame.game.ability.Guidance;
import mygame.game.ability.Volume;
import mygame.game.ability.Position;
import mygame.client.view.GameView;
import mygame.client.model.UnitSelection in UnitSelectionModel;
import utils.three.Coordonate;
import trigger.*;

import space.Vector3 in Vector;

import mygame.client.view.visual.unit.UnitVisual;

/**
 * 
 * @author GINER Jérémy
 */
class UnitSelectionPreview implements IVisual implements ITrigger {
	
	var _oGameView :GameView;
	
	var _oModel :Model;
	var _oSelection :UnitSelectionModel;
	
	var _oSelectionHint :Object3D;
	
	
//______________________________________________________________________________
//	Constructor
		
	public function new( oGameView :GameView, oModel :Model ){
		_oGameView = oGameView;
		_oModel = oModel;
		
		//_____
		
		_oSelectionHint = new Mesh( 
			cast new RingGeometry( 1.1, 1.2, 32, 3 ), 
			new MeshBasicMaterial(
				{ color: 0xCCCCCC, wireframe: true }
			)
		);
		_oSelectionHint.scale.set( 0.2, 0.2, 0.2 );
		//_oSelection.position.set(0,0,0.1);
		_oSelectionHint.castShadow = true;
		
		//_____
		
		_oSelection = oModel.GUI_get().unitSelection_get();
		
		
		//____
		
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
	
	function _selectionPreview_update( x :Int, y :Int ) {
		
		// Get target
		var oUnitVisual = UnitVisual.get_byRaycasting( x, y, _oGameView );
		
		// Get Target Object3D
		var oObject :Object3D = null;
		if ( oUnitVisual != null )
			oObject = oUnitVisual.object3d_get();
		
		// Update selection hint
			// Remove old
			if ( _oSelectionHint.parent != oObject && _oSelectionHint.parent != null )
				_oSelectionHint.parent.remove( _oSelectionHint );
			
			// Add new
			if ( oObject != null ) {
				_oSelectionHint.scale.set( 
					oUnitVisual.selectionScale_get(),
					oUnitVisual.selectionScale_get(),
					oUnitVisual.selectionScale_get() 
				);
				oObject.add( _oSelectionHint );
			}
	}
	
//______________________________________________________________________________
//	Trigger
	
	public function trigger( oSource :IEventDispatcher ) {
		
		if ( oSource == _oModel.mouse_get().onMove ) {
			_selectionPreview_update( 
				_oModel.mouse_get().x_get(), 
				_oModel.mouse_get().y_get() 
			);
		}
		
	}
}