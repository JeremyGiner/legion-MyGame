package legion.entity;

import legion.entity.Entity;
import haxe.ds.IntMap;

class PlayerTeam extends Entity {
	
	var _aPlayer :Array<Player>;
	
//______________________________________________________________________________
//	Constructor

	public function new( oGame :Game ){
		super( oGame );
		
		_aPlayer = new Array<Player>();
	}
	
//______________________________________________________________________________
//	Accessor

	public function player_add( oPlayer :Player) {
		_aPlayer.push( oPlayer );
	}
}