package mygame.game.process;

import legion.entity.Entity;
import mygame.game.MyGame;
import mygame.game.entity.Unit;

//import mygame.game.collision.UnitTile in CLayerUnitTile;
import collider.CollisionEventPrior in CollisionEvent;

import trigger.*;
import trigger.eventdispatcher.*;

import mygame.game.ability.Mobility;
import mygame.game.ability.Volume;
import mygame.game.ability.Guidance;


/*
 * - Get velocity
 * - Unit push each other 
 * - Clamp to map (require velocity)
 * - apply new position
 */
class MobilityProcess implements ITrigger {

	var _oGame :MyGame;
	var _loUnit :List<Unit>;

//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame ) {
		_oGame = oGame;
		_loUnit = new List<Unit>();
		
		//_oCLayerUnitTile = new CLayerUnitTile();
		//new MobilityMapClamp( _oCLayerUnitTile );
		
		_oGame.onLoop.attach( this );
		_oGame.onEntityNew.attach( this );
		_oGame.onEntityDispose.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor
	

	
//______________________________________________________________________________
//	Process
	
	function process() {
	
		// Guidance process
		var lUnitDelete = new List<Unit>();
		for( oUnit in _loUnit ) {
			var oGuidance :Guidance = oUnit.ability_get( Guidance );
			if( oGuidance != null )
				oGuidance.process();
			else
				if( oUnit.ability_get( Mobility ) == null )
					lUnitDelete.push( oUnit );	// collect to be removed later
		}
		
		// Cleaning
		for( oUnit in lUnitDelete ) {
			_loUnit.remove( oUnit );
		}
		
		// Move each entity
		for( oUnit in _loUnit ) {
			oUnit.ability_get( Mobility ).move();
			//_oGame.onUnitMove.dispatch( oUnit );
		}
		
	} 
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		// on loop
		if( oSource == _oGame.onLoop )
			process();
		
		// on new mobile entity
		if( oSource == _oGame.onEntityNew ) {
			
			if( Std.is(oSource.event_get(),Unit) ) {
				var oUnit :Unit = cast oSource.event_get();
				if( oUnit.ability_get( Mobility ) != null ) {
					_loUnit.add( oUnit );
				}/*
				if( oUnit.ability_get( Volume ) != null ) {
					_oCLayerUnitTile.add( oUnit );
				}*/
			}
		}
		
		// on entity remove
		if( oSource == _oGame.onEntityDispose ) {
			_loUnit.remove( cast oSource.event_get() );
			//_oCLayerUnitTile.remove( cast oSource.event_get() );
		}
	
	}
}