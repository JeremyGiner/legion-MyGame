package mygame.client.controller.game;


import js.three.*;

import legion.device.MegaMouse in Mouse;

import mygame.client.view.GameView;

import trigger.*;

import utils.three.Coordonate;

import Math;

class StrategicZoom implements ITrigger {
	
	var _oGameView :GameView;
	
	var _oMouse :Mouse;
	
	static var _fMin :Float = 0; //TODO : rendre fonctionnel
	static var _fMax :Float = 50;
	static var _fStepQuant :Float = 10;
	

//____________________________________________________________________________
//	Constructor

	public function new( oGameView :GameView, oMouse :Mouse ){

		_oGameView = oGameView;	//TODO  test if not null;
		_oMouse = oMouse;
		
		_oMouse.onWheel.attach(this);
	}

//____________________________________________________________________________

	function move( oMouse :Mouse  ){
		
		var oVector = new Vector3();
		
		var fZoomIntensity = ( _fMax - _fMin ) /_fStepQuant;
		
		if( oMouse.wheel_get() >0 ){
			// Zoom in
			
			// Get 3D pos of mouse
				oVector = Coordonate.screen_to_worldGround( 
					oMouse.x_get(), 
					oMouse.y_get(), 
					_oGameView.renderer_get(), 
					_oGameView.camera_get()
				);
			
			// Get Vector : camera position to Mouse position
			oVector = untyped oVector.sub( _oGameView.camera_get().position );
			
			//oVector = oVector.setLength( fZoomIntensity );
			oVector = untyped oVector.multiplyScalar(0.25);

			_oGameView.camera_get().position.add(oVector);
			_oGameView.camera_get().position.setZ( 
				Math.max( 
					_oGameView.camera_get().position.z,
					_fMin
				)
			);
		}else{
			// Zoom out

			// Get vector length fZoomIntensity and direction equal to camera's direction
				oVector.set( 0, 0, fZoomIntensity );
				var oMatrixRotation :Matrix4 = new Matrix4();
				oMatrixRotation.extractRotation( _oGameView.camera_get().matrix ); 
				oVector = oVector.applyMatrix4(oMatrixRotation);
				
			_oGameView.camera_get().position.add(oVector);
			_oGameView.camera_get().position.setZ( 
				Math.min( 
					_oGameView.camera_get().position.z,
					_fMax
				)
			);
		}
	}
	
	public function trigger( oSource :IEventDispatcher ){

		if( oSource == _oMouse.onWheel )
			move( cast oSource.event_get() );
	}
}
