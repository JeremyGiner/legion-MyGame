package mygame.game.ability;

import haxe.ds.IntMap;
import legion.ability.IAbility;
import space.Circle;
import space.Circlei;
import space.Vector2i;
import space.Vector3;
import mygame.game.ability.Position;
import mygame.game.entity.Unit;
import mygame.game.entity.Player;
//import mygame.game.collision.LoyaltyShiftLayer in CollisionLayer;

import collider.CollisionCheckerPostInt;

class LoyaltyShift extends UnitAbility {
	
	var _fLoyalty :Float; //Percent
	var _oChallenger :Player;
	//var _oCollidingLayer :CollisionLayer;
	
	static var _fStep :Float = 0.01; // Must be inferior to 0.5
	static var _oArea :Circlei = { new Circlei( new Vector2i(), RANGE ); };

	public static inline var RANGE = 10000;
	
//______________________________________________________________________________
//	Constructor

	public function new( oUnit :Unit ) {
		//require position
		super( oUnit );
		_fLoyalty = 1;
		_oChallenger = _oUnit.owner_get();
		if( _oChallenger == null )
			_fLoyalty = 0;
	}

//______________________________________________________________________________
//	Accessor
	
	public function area_get() {
		_oArea.position_get().copy( _oUnit.ability_get(Position) );
		return _oArea;
	}
	
	public function loyalty_get() { return _fLoyalty; }
	public function challenger_get() { return _oChallenger; }
	
//______________________________________________________________________________
// Prototype
	
	//TODO : move to collision layer
	public function test() :IntMap<Int> {
		var mCount = new IntMap<Int>();
		
		// Test each unit
		var oGame :MyGame = cast _oUnit.game_get();
		for ( oUnit in oGame.unitList_get() ) {
			
			// Check unit
			if( _oUnit == oUnit ) continue;
			if( oUnit.ability_get( LoyaltyShifter ) == null ) continue;
			
			var oPlayer = oUnit.owner_get();
			if( oPlayer != null )
				if( unit_check( oUnit ) )
					//Then add to the count
					if( mCount.exists( oPlayer.playerId_get() ) ) {
						mCount.set( oPlayer.playerId_get(),  mCount.get( oPlayer.playerId_get() )+1 );
					} else
						mCount.set( oPlayer.playerId_get(), 1 );
		}
		return mCount;
	}
	
	function unit_check( oUnit :Unit )	{
		
		var oPosition = oUnit.ability_get( Position );
		if( oPosition == null ) return false;
		if( !CollisionCheckerPostInt.check( area_get(), oPosition ) ) return false;
		return true;
	}


//______________________________________________________________________________
//	Process
	
	public function process() {
		var oGame = _oUnit.mygame_get();
	
		if ( _fLoyalty == 0 ) {
			
			
			// Count unit group for each player inside the area of this.unit
			var mCount = test();
			
			// Check if count is empty
			if( !mCount.keys().hasNext() ) return;
			
			// Get highest and second highest count
			var oChallenger :Player = null;
			var oChallengerSecond :Player = null;
			for( iPlayerId in mCount.keys() ) {
				if( oChallenger == null ) 
					oChallenger = oGame.player_get( iPlayerId );
				else
				if( mCount.get( oChallenger.playerId_get() ) < mCount.get( iPlayerId ) ) 
					oChallenger = oGame.player_get( iPlayerId );
				else {
					if( oChallengerSecond == null ) 
						oChallengerSecond = oGame.player_get( iPlayerId );
					else
					if( mCount.get( oChallengerSecond.playerId_get() ) < mCount.get( iPlayerId ) ) 
						oChallengerSecond = oGame.player_get( iPlayerId );
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
				_oChallenger = oChallenger;
				if( _oChallenger != null )
					loyalty_increase();
			}
			
		} else {
		
			// Count unit group for each player inside the area of this.unit
			var mCount = test();
			
			// Check if count is empty
			if( !mCount.keys().hasNext() ) return;
			
			// Get player with the biggest count of unit
			var oChallenger :Player = null;
			for( oPlayer in mCount.keys() ) {
				if( oChallenger == null ) 
					oChallenger = oGame.player_get( oPlayer );
				else
				if( mCount.get( oChallenger.playerId_get() ) < mCount.get( oPlayer ) ) 
					oChallenger = oGame.player_get( oPlayer );
			}
			
			// Compare count with current challenger
			if( oChallenger == _oChallenger ) 
				loyalty_increase();
			else
				loyalty_decrease();
			
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
	
//______________________________________________________________________________
//	Sub-routine

	function loyalty_increase() {
		_fLoyalty += _fStep;
		if( _fLoyalty >= 0.5 ) 
			 _oUnit.owner_set( _oChallenger );
		_fLoyalty = Math.min( _fLoyalty, 1 );
	}
	function loyalty_decrease() {
		_fLoyalty -= _fStep;
		if( _fLoyalty < 0.5 ) 
			 _oUnit.owner_set( null );
		_fLoyalty = Math.max( _fLoyalty, 0 );
	}
	

}