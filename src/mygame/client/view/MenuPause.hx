package mygame.client.view;

import mygame.client.model.UnitSelection;
import js.html.DivElement;
import mygame.client.model.RoomInfo;
import trigger.*;
import trigger.eventdispatcher.EventDispatcher;

import mygame.client.model.Model;

class MenuPause implements ITrigger {
	
	var _oDiv :DivElement;
	var _oModel :Model;
	var _oRoomInfo :RoomInfo;

//______________________________________________________________________________
//	Constructor

	public function new( oModel :Model, oDiv :DivElement ) {
		_oModel = oModel;
		_oDiv = oDiv;
		_oRoomInfo = _oModel.roomInfo_get();
		
		if ( _oRoomInfo == null )
			throw('[ERROR] MenuPause : no room info found');
		
		update();
		
		_oRoomInfo.onUpdate.attach( this );
	}
	
//______________________________________________________________________________
//	
	
	function update() {
		
		// Cleaning
		_oDiv.innerHTML = '';
		
		// Print
		_oDiv.innerHTML = render();
		
	}
	
	function render() :String {
		
		// Hide if not paused
		_oDiv.style.display = ( _oRoomInfo.isPaused() ) ? '' : 'none';
		
		var s = '<h1>Paused</h1><table><tbody>';
		
		for ( oUserInfo in _oRoomInfo.userInfoList_get() ) {
			s += '<tr><td>' + oUserInfo.name + '</td>';
			s += '<td><input '; 
			if( _oModel.playerLocal_get().playerId_get() == oUserInfo.playerId )
				s += ' data-haxeAction="' + (( oUserInfo.ready )?'pause':'unpause') + '" ';
			else
				s += ' disabled ';
			s += ' type="checkbox" ';
			if ( oUserInfo.ready ) 
				s += ' checked ';
			s += ' /></td></tr>';
		}
		s += '</tbody></table>';
		
		return s;
	}
	
//______________________________________________________________________________
//	Trigger
	
	public function trigger( oSource :IEventDispatcher ) {
		// On room status update
		update();
	}
}