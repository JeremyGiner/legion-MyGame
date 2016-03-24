package mygame.game.action;

import mygame.game.entity.Unit;
import legion.entity.Player;
import legion.PlayerInput in PlayerInputBase;

import space.Vector3 in Vector2;

class PlayerInput /*extends PlayerInputBase<MyGame>*/ {
	
//______________________________________________________________________________
// Constructor

	public function new( 
		oPlayer :Player,
		oDirection :Vector2
	) {
		if( !_bInit ) init();
		super( oPlayer );
		
		_oDirection = oDirection;
	}

//______________________________________________________________________________
// 

	function init() {
		
		_bInit = true;
	}
	
//______________________________________________________________________________
// Utils
	
	public function exec( oGame :MyGame ) { }
	
	public function check( oGame :MyGame ) :Bool { return true; }
	
}