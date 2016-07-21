package mygame.game.process;

import haxe.ds.IntMap;
import legion.entity.Entity;
import legion.entity.Player;
import mygame.game.ability.Loyalty;
import mygame.game.ability.LoyaltyShifter;
import mygame.game.MyGame;
import mygame.game.entity.Unit;
import mygame.game.query.EntityQuery;
import mygame.game.query.EntityDistance;
import mygame.game.query.ValidatorEntity;

import collider.CollisionEventPrior in CollisionEvent;

import trigger.*;
import trigger.eventdispatcher.*;

import mygame.game.ability.LoyaltyShift;

class LoyaltyShiftProcess implements ITrigger {

	var _oGame :MyGame;
	var _oQueryLoyaltyShift :EntityQuery;
	var _oQueryLoyaltyShifter :EntityQuery;

//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame ) {
		_oGame = oGame;
		
		_oQueryLoyaltyShift = new EntityQuery( _oGame, new ValidatorEntity([ 'ability' => LoyaltyShift ]) );
		_oQueryLoyaltyShifter = new EntityQuery( _oGame, new ValidatorEntity([ 'ability' => LoyaltyShifter ]) );
		
		_oGame.onLoop.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor
	

//______________________________________________________________________________
//	Process
	
	function process() {
		
		// Process each ability LoyaltyShift
		for( oEntity in _oQueryLoyaltyShift.data_get(null) ) {
			var oLoyaltyShift = oEntity.ability_get(LoyaltyShift);
			_process( oLoyaltyShift );
		}
		
	}
	
//______________________________________________________________________________
//	Sub-routine

	function _process( oLoyaltyShift :LoyaltyShift ) {
		// Count unit group for each player inside the area of this.unit
		var mCount = _count_get( oLoyaltyShift );
		
		// Check if count is empty
		if( !mCount.keys().hasNext() ) return;
		
		if ( oLoyaltyShift.loyalty_get() == 0 ) {
			
			// Get highest and second highest count
			var oChallenger :Player = null;
			var oChallengerSecond :Player = null;
			for( iPlayerId in mCount.keys() ) {
				if( oChallenger == null ) 
					oChallenger = _oGame.player_get( iPlayerId );
				else
				if( mCount.get( oChallenger.playerId_get() ) < mCount.get( iPlayerId ) ) 
					oChallenger = _oGame.player_get( iPlayerId );
				else {
					if( oChallengerSecond == null ) 
						oChallengerSecond = _oGame.player_get( iPlayerId );
					else
					if( mCount.get( oChallengerSecond.playerId_get() ) < mCount.get( iPlayerId ) ) 
						oChallengerSecond = _oGame.player_get( iPlayerId );
				}
			}
			
			// Compare highest and second-highest
			if( 
				oChallenger != null && 
				(
					oChallengerSecond == null ||
					( 
						oChallengerSecond != null && 
						mCount.get( oChallenger.playerId_get() ) > mCount.get( oChallengerSecond.playerId_get() )
					)
				)
			) {
				// Update challenger and loyalty
				oLoyaltyShift.challenger_set( cast oChallenger );
				if ( oLoyaltyShift.challenger_get() != null )
					oLoyaltyShift.loyalty_increase();
			}
			
		} else {
			
			// Get player with the biggest count of unit
			var oChallenger :Player = null;
			for( oPlayer in mCount.keys() ) {
				if( oChallenger == null ) 
					oChallenger = _oGame.player_get( oPlayer );
				else
				if( mCount.get( oChallenger.playerId_get() ) < mCount.get( oPlayer ) ) 
					oChallenger = _oGame.player_get( oPlayer );
			}
			
			// Compare count with current challenger
			if( oChallenger == oLoyaltyShift.challenger_get() ) 
				oLoyaltyShift.loyalty_increase();
			else
				oLoyaltyShift.loyalty_decrease();
			
		}
		
		// 0% ->
			// Group unit by owner count and highest and second highest
			// if highest != of second highest 
			// -> increase loyalty and set challenger to this player
	
		// [100%;0%[ ->
			// Count challenger's unit
			// Count any other
			// Compare 
			// inferior -> decrease loyalty
			// superior -> increase loyalty
		
		// 
		
		//visual : 
		// if challenger is not local player 
		//		[Local player | neutral | challenger]
		// if challenger is local player 
		//		[Local player | neutral | any ennemy player]
	}
	
	function _count_get( oLoyaltyShift :LoyaltyShift ) {
		var mCount = new IntMap<Int>();
		
		// Test each unit
		for ( oUnit in _oQueryLoyaltyShifter.data_get(null) ) {
			
			// Filter neutral unit
			var oPlayer = oUnit.ability_get(Loyalty).owner_get();
			if ( oPlayer == null )
				continue;
			
			// Filter unit out of range
			var fDist = _oGame.singleton_get(EntityDistance).data_get([ oLoyaltyShift.unit_get(), cast oUnit ]).get();
			if ( fDist == null )
				continue;
			if ( fDist > oLoyaltyShift.radius_get() )
				continue;
			
			//Then add to the count
			if( mCount.exists( oPlayer.playerId_get() ) ) {
				mCount.set( oPlayer.playerId_get(),  mCount.get( oPlayer.playerId_get() )+1 );
			} else
				mCount.set( oPlayer.playerId_get(), 1 );
		}
		return mCount;
	}
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		// on loop
		if( oSource == _oGame.onLoop )
			process();
	}
}