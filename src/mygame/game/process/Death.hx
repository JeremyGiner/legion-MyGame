package mygame.game.process;

import haxe.ds.IntMap;
import legion.entity.Entity;
import mygame.game.MyGame;
import mygame.game.ability.Health;

import trigger.*;

class Death implements ITrigger {

	var _oGame :MyGame;
	var _aEntity :IntMap<Entity>; // Map of entity which Health have been recently updated, indexed by id

//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame ) {
		_oGame = oGame;
		_aEntity = new IntMap<Entity>();
		
		// Trigger
		_oGame.onLoop.attach( this );
		_oGame.onHealthAnyUpdate.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor
	

	
//______________________________________________________________________________
//	Process
	
	function process() {
		
		// Process each unit
		for ( oEntity in _aEntity ) {
			
			// Skip living unit
			if ( oEntity.ability_get(Health).get() > 0 )
				continue;
			
			// Case : dead -> dispose entity
			oEntity.game_get().entity_remove( oEntity );
		}
		
		// Reset
		_aEntity = new IntMap<Entity>();
	} 
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		// on loop
		if( oSource == _oGame.onLoop )
			process();
		
		// on 
		if ( oSource == _oGame.onHealthAnyUpdate ) {
			var oUnit = _oGame.onHealthAnyUpdate.event_get().unit_get();
			_aEntity.set( oUnit.identity_get(), oUnit );
		}
		
	}
}