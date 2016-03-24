package mygame.game.collision;

//import collider.CollisionLayer;

import mygame.game.entity.Unit;
import mygame.game.ability.Position;
import mygame.game.ability.Mobility;
import mygame.game.ability.Volume;
import mygame.game.ability.Guidance;
import mygame.game.MyGame;
import trigger.*;
import collider.CollisionEventPrior in CollisionEvent;

import mygame.game.tile.*;

import mygame.game.tile.Tile;


/**
 * Post collision layer between volume ability
 * 
 * must be contructed before game start
 * 
 */
class UnitVolume {
	
	var _oGame :MyGame;
	var _lVolume :List<Volume>;
	
	public var onCollision :EventDispatcher2<CollisionEvent>;
	
//______________________________________________________________________________
// Constructor

	public function new( oGame :MyGame ) {
		_oGame = oGame;
		_loUnit = new List<Unit>();
		
		_oGame.onEntityNew.attach( this );	//To collect new volume
		_oGame.onAbilityDispose.attach( this );
		
		onCollision = new EventDispatcher2<CollisionEvent>();
	}
	
//______________________________________________________________________________
// Accessor

	public function _add( o :Volume ) { 
		_lVolume.add( o ); 
	}
	public function _remove( o :Volume ) {  
		_lVolume.remove( o );
	}
	
	public function collisionEventLast_get() { return _oCollisionEvent; }

//______________________________________________________________________________
// Collision
	
	public function collision_check() :Int {
	
		var iCollisionQuantity :Int = 0;
	
		// Collision check between a unit mobility 
		// and his surrounding (non-walkable) tiles.
		for( oUnit in _loUnit ) {
		
			//TODO
			
			// Dispatch collision event
			if( oCollisionMin != null ) {
			
				iCollisionQuantity++;
				onCollision.dispatch( 
					oCollisionMin
				);
			}
		}
		return iCollisionQuantity;
	}
	
//______________________________________________________________________________
// Trigger
	
	public function trigger( oSource :IEventDispatcher ) {
		if ( oSource == _oGame.onEntityNew ) 
			_add( _oGame.onEntityNew.event_get() );
		
		if ( oSource == _oGame.onAbilityDispose )
			if ( Std.is( _oGame.onAbilityDispose, Volume )
				_remove( cast _oGame.onAbilityDispose.event_get() );
	}

}