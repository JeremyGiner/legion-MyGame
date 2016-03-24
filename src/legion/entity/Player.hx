package legion.entity;

import legion.entity.Entity;
import haxe.ds.IntMap;

class Player extends Entity {
	
	var _iPlayerId :Int;
	var _sName :String;
	var _oPlayerTeam :PlayerTeam;
	
//______________________________________________________________________________
//	Constructor

	public function new( oGame :Game, sName :String = 'Annonymous' ){
		super( oGame );
		_sName = sName;
		_oPlayerTeam = new PlayerTeam( oGame );
	}
	
//______________________________________________________________________________
//	Accessor

	public function name_get(){ return _sName; }


	public function playerId_get() { return _iPlayerId; }
	//TODO : remove
	public function playerId_set( iPlayerId :Int ) {
		_iPlayerId = iPlayerId;
	}
	
	public function alliance_get( oPlayer :Player ) {
		if( this == oPlayer ) return 'ally';
		return 'ennemy';
	}
}