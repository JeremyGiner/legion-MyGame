package mygame.client.controller;

import js.Browser;
import js.Lib;
import mygame.client.model.RoomInfo;
import mygame.client.view.MenuPause;
import mygame.game.MyGame;
import legion.PlayerInput;

import trigger.*;
import trigger.eventdispatcher.*;

import mygame.trigger.*;

import mygame.client.controller.game.IGameController;
import mygame.client.controller.game.GameControllerLocal;
import mygame.client.controller.game.GameControllerOnline;

import mygame.client.model.Model;

import mygame.client.view.View;
import mygame.client.view.GameView;

import mygame.connection.message.*;
import mygame.connection.message.serversent.RoomStatus;

import js.html.ButtonElement;
import js.html.Element;
import js.html.InputElement;

class Controller implements ITrigger {

	var _oModel :Model;
	var _oView :View;

	var _oGameController :IGameController = null;
	
	//_____
	
	var _oMenuStartNew :ButtonElement;
	var _oMenuOnlineNew :ButtonElement;
	var _oMenuRefresh :ButtonElement;
	var _oMenuConnect :ButtonElement;
	var _oMenuGameJoin :ButtonElement;
	var _oMenuGameList :Element;
	var _oMenuConnStatus :Element;
	
	var _oBtShutDown :ButtonElement;
	
	var _onButtonClick :EventDispatcherJS;
	
//______________________________________________________________________________
//	Constructor

	public function new( oModel :Model, oView :View ){
		_oModel =  oModel;
		_oView = oView;
		
		// Menu
		_onButtonClick = new EventDispatcherJS('mouseup');
		_onButtonClick.attach( this );
		
		_oMenuStartNew = cast js.Browser.document.getElementById('BtLocalNew');
		_oMenuOnlineNew = cast js.Browser.document.getElementById('BtRemoteNew');
		_oMenuConnect = cast js.Browser.document.getElementById('BtConnect');
		_oMenuRefresh = cast js.Browser.document.getElementById('BtRefresh');
		_oBtShutDown = cast js.Browser.document.getElementById('BtShutDown');
		_oMenuGameJoin = cast js.Browser.document.getElementById('BtGameJoin');
		_oMenuGameList = cast js.Browser.document.getElementById('GameList');
		_oMenuConnStatus = cast js.Browser.document.getElementById('LabelStatus');
	}

//______________________________________________________________________________
// Utils

	public function game_start( 
		oGame :MyGame = null, 
		iPlayerSlot :Int = 0,
		bOnline :Bool = false
	){
		if( oGame == null )
			oGame = new MyGame();
		
		// TODO : game config
		// TODO : dispose of previous game
		
		// Update model
		_oModel.game_set( oGame, iPlayerSlot );
		
		// Delegate to game controller
		if( bOnline ) {
			_oGameController = new GameControllerOnline( 
				_oModel,
				100	//TODO :put dynamic value, and timeout system
			);
		} else {
			_oGameController = new GameControllerLocal( 
				_oModel
			);
		}
	}
	
	public function game_load() {
		
	}
	
	public function game_save() {
		
	}

	public function game_end() {
		//TODO
	}
	
	public function gameController_get() {
		return _oGameController;
	}
	
//________________________________

	public function connect() {
		trace( 'Connecting..' );
		_oModel.connection_new();
		_oModel.connection_get().connect();
		_oModel.connection_get().onOpen.attach( this );
		_oModel.connection_get().onMessage.attach( this );
		_oModel.connection_get().onClose.attach( this );
		
		_oMenuConnect.innerHTML = 'Loading';
		_oMenuConnect.disabled = false;
	}
	public function disconnect() {
		trace( 'Disconnecting..' );
		_oModel.connection_get().close();
	}
	
	function gameList_refresh( oSlotList :ResSlotList ) {
		// Clear the list
		_oMenuGameList.innerHTML = '';
						
		// Print list
		var oElement :Element;
		var bFirst :Bool = true;
		var s :String;
		for( iGameId in oSlotList.liGameId ) {
			s = '';
			s +=
				'<div>
					<input id="GameSelector'+iGameId+'" type="radio" name="GameSelector" value="'+iGameId+'"';
			if( bFirst ) {
				s += 'checked';
				bFirst = false;
			}
			s +=
						'>
				<label for="GameSelector'+iGameId+'">Game #'+iGameId+'</label>
			</div>';//'"
								
			_oMenuGameList.innerHTML += s;
		}
	}
	
	public function join( iGameId :Int ) {
		if( _oModel.connection_get() == null ) {
			throw 'no connection established yet.';
			return;
		}
		//_oModel.connection_get().game_join( iGameId );
	}


//______________________________________________________________________________
// Trigger
	
	public function trigger( oSource :IEventDispatcher ) {
		
	// Menu buttons
		if( oSource.event_get().target == _oMenuStartNew ) {
			trace( 'Starting new local game' );
			game_start();
			return;
		}
		
		// Connection toggle
		if( oSource.event_get().target == _oMenuConnect ) {
			if( _oModel.connection_get() != null && _oModel.connection_get().open_check() ) {
				disconnect();
			} else {
				connect();
			}
			return;
		}
		
	// Connection
		if( _oModel.connection_get() != null ) {
		
			// TODO : move to MenuView
			if( oSource == _oModel.connection_get().onOpen ) {
				_oMenuConnStatus.innerHTML = 'Status : Connected.';
				
				_oMenuConnect.innerHTML = 'Disconnect';
				_oMenuConnect.disabled = false;
				
				_oMenuOnlineNew.disabled = false;
				_oMenuRefresh.disabled = false;
				_oMenuGameJoin.disabled = false;
				
				return;
			}
			// TODO : move to MenuView
			if( oSource == _oModel.connection_get().onClose ) {
				_oMenuConnStatus.innerHTML = 'Status : Disconnected.';
				_oMenuConnect.innerHTML = 'Connect';
				_oMenuConnect.disabled = false;
				return;
			}
			
			// Connected
			if( _oModel.connection_get().open_check() ) {
			
				// Resquest sender
				if( oSource.event_get().target == _oMenuRefresh ) {
					// Requesting game and slot list
					trace('Requesting slot list');
					_oModel.connection_get().send( new ReqSlotList() );
				}
				if( oSource.event_get().target == _oMenuGameJoin ) {
				
					// Get selected game of the list
					var iGameId :Int=-1;
					var loElement = js.Browser.document.getElementsByName('GameSelector');
					for( oElement in loElement ) {
						if(  cast(oElement,InputElement).checked ) {
							iGameId = Std.parseInt( cast(oElement,InputElement).value );
							break;
						}
					}
					trace('Requesting an access to game #'+iGameId);
					// Requesting slot attachement to this client
					_oModel.connection_get().send( new ReqGameJoin(iGameId) );
				}
				
				if ( oSource.event_get().target == _oBtShutDown ) {
					_oModel.connection_get().send( new ReqShutDown() );
				}
				
				if( oSource == _oModel.connection_get().onMessage ) {
					
					var oMessage = _oModel.connection_get().messageLast_get();
					if( !Std.is(oMessage,ILobbyMessage) ) return; // Process only LobbyMessage
					switch( Type.getClass( oMessage ) ) {
						case ResGameStepInput :
							//trace('game step receive');
						case ResSlotList :
							trace('slot list receive');
							gameList_refresh( cast oMessage );
							
						case ResGameJoin :	
							var oRespond = cast( oMessage, ResGameJoin );
							trace('[NOTICE]:game instance receive (step:'+oRespond.oGame.loopId_get()+').');
							game_start(
								oRespond.oGame,
								oRespond.iSlotId,
								true
							);
							
						case RoomStatus : 
							trace('[NOTICE]:updating room');
							var oRoomStatus = cast(oMessage, RoomStatus);
							
							var oRoomInfo = _oModel.roomInfo_get();
							
							if ( oRoomInfo == null )
								_oModel.roomInfo_set( new RoomInfo( oRoomStatus ) )
							else
								oRoomInfo.update( oRoomStatus );
						
							new MenuPause( _oModel, cast Browser.document.getElementById('MENU-PAUSE') );
						default :
							trace('[ERROR]:unknow command/respond from server:'+oMessage);
					}
				}

			}
			
		}
		
	}
}