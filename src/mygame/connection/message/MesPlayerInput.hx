package mygame.connection.message;

import mygame.game.action.IAction;

import space.Vector3;
import mygame.game.action.UnitDirectControl;

class MesPlayerInput implements IGameMessage {
	
	var _sSerial :String;
	
	var _oAction :IAction;
	
	public function new( oAction :IAction ) {
		
	}
	
	public function action_get( oPlayer ) :IAction { 
		return null;
	}
	/*
	@:keep
    function hxSerialize( s:Serializer ) {
        s.serialize(x);
    }

    @:keep
    function hxUnserialize( u:Unserializer ) {
        x = u.unserialize();
        y = -1;
    }*/
	
}