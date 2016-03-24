package mygame.game.entity;

import mygame.game.MyGame in Game;
import legion.entity.Player in PlayerBase;

class Player extends PlayerBase {
	
	var _iCredit :Int;
	
//______________________________________________________________________________
//	Constructor
	
	public function new( oGame :Game, sName :String = 'Annonymous' ){
		super( oGame, sName );
		_iCredit = 30;
	}
	
//______________________________________________________________________________
//	Accessor
	
	public function credit_get() { return _iCredit; }
	public function credit_add( iDelta :Int ) { 
		_iCredit += iDelta;
		return credit_get();
	}
}