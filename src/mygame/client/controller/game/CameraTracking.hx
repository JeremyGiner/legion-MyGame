package mygame.client.controller.game;

import mygame.game.entity.Unit;
import mygame.game.process.MobilityProcess;
import mygame.client.view.GameView;
import trigger.*;


class CameraTracking implements ITrigger {
	
	var _oUnit :Unit;
	var _oGameView :GameView;
	
	public function new( oUnit :Unit, oGameView :GameView ) {
		_oUnit = oUnit;
		_oGameView = oGameView;
		
		
		MobilityProcess.onAnyMove.attach( this );
	}

//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		_oGameView.camera_get().position.setX( _oUnit.mobility_get().position_get().x *50  );
		_oGameView.camera_get().position.setY( _oUnit.mobility_get().position_get().y *50 -300 );
	}
	
}