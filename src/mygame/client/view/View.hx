package mygame.client.view;

import mygame.client.view.GameView;
import mygame.game.MyGame;

import trigger.*;

import mygame.client.model.Model;
import mygame.client.view.View;

class View implements ITrigger {

	var _oModel :Model;

	var _oGameView :GameView = null;
	
	var _oMenuPause :MenuPause = null;
	
//______________________________________________________________________________
//	Constructor

	public function new( oModel :Model ){
		_oModel = oModel;

		//TODO : lsiten _oModel.onUpdate.attach()
	}

//______________________________________________________________________________
//	Modifier
	
//______________________________________________________________________________
// Utils

	public function update() {
	
	}

//______________________________________________________________________________
// Trigger
	
	public function trigger( oSource :IEventDispatcher ) {
		/*
		// Create view on new game
		if( _oGameView == null && _oModel.game_get() != null )
			_oGameView = new GameView( _oModel.game_get() );*/
		
	}
}