package mygame.game.process;

import haxe.ds.IntMap;
import legion.entity.Entity;
import mygame.game.ability.Platoon;
import mygame.game.MyGame;
import mygame.game.ability.Health;
import mygame.game.query.EntityQuery;
import mygame.game.query.ValidatorEntity;

import trigger.*;

class DeathPlatoon implements ITrigger {

	var _oGame :MyGame;
	
	var _oQueryPlatoon :EntityQuery;

//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame ) {
		_oGame = oGame;
		_oQueryPlatoon = new EntityQuery( _oGame, new ValidatorEntity(['ability' => Platoon ]) );
		
		// Trigger
		_oGame.onLoop.attach( this );	// TODO place after Death process
	}
	
//______________________________________________________________________________
//	Accessor
	

	
//______________________________________________________________________________
//	Process
	
	function process() {
		
		// Process each unit
		for ( oEntity in _oQueryPlatoon.data_get(null) ) {
			
			// Skip living unit
			if ( oEntity.ability_get(Platoon).subUnit_get().length != 0 )
				continue;
			
			// Case : dead -> dispose entity
			oEntity.game_get().entity_remove( oEntity );
		}
	} 
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		// on loop
		if( oSource == _oGame.onLoop )
			process();
		
	}
}