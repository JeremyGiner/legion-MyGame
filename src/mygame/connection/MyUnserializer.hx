package mygame.connection;

import legion.Game;
import haxe.Unserializer;

/**
 * Unserialize string serialized with MySerializer and haxe Serializer
 * @author GINER Jérémy
 */

class MyUnserializer extends Unserializer {
	
	var _oGame :Game;

//______________________________________________________________________________
//	Constructor
	
	// TODO: find a way to move string parameter to the unserialize() method
	override function new( s :String, oGame :Game ) {
		super(s);
		game_set( oGame );
	}
//______________________________________________________________________________
//	
	
	function game_set( oGame :Game ) {
		_oGame = oGame;
	}

//______________________________________________________________________________
//	
	
	override public function unserialize() :Dynamic {
		switch( get( pos++ ) ) {
			case 'U'.code :	//Special
				
				// Retrieve Identity
				var id = unserialize();
				
				// Get entity from game
				var v = _oGame.entity_get( id );
				
				// Check validity
				if ( v == null ) throw('No reference for Entity #' + id + ' for given game');
				
				//__
				return v;
				
			default :
				pos--;
				return super.unserialize();
		}
	}
	
//______________________________________________________________________________
//
	
	
	static public function run( s :String, oGame :Game ) {
		return new MyUnserializer(s,oGame).unserialize();
	}
}