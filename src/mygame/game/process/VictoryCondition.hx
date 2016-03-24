package mygame.game.process;

import haxe.ds.IntMap;
import legion.entity.Entity;
import mygame.game.MyGame;
import mygame.game.ability.Weapon;
import mygame.game.entity.Unit;
import mygame.game.entity.Player;
import mygame.game.collision.WeaponLayer;
import mygame.game.ability.LoyaltyShift;

import trigger.*;

/**
 * WIP
 */
class VictoryCondition implements ITrigger {

	var _oGame :MyGame;
	
	var _fVictory :Float; //Percent
	var _oChallenger :Player;	//TOOD: use team
	
	var _mObjectif :IntMap<List<Unit>>;	// Objectif unit indexed by player id

//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame ) {
		_oGame = oGame;
		_fVictory = 0;
		_oChallenger = null;
		_mObjectif = new IntMap<List<Unit>>();
		
		// Assuming there is 2 player
		_mObjectif.set( 0, new List<Unit>() );
		_mObjectif.set( 1, new List<Unit>() );
		
		
		//
		_oGame.onLoop.attach( this );
		
		// on unit change owner
		// on unit death
		
	}
	
//______________________________________________________________________________
//	Accessor
	
	public function challenger_get() {
		return _oChallenger;
	}
	
	public function value_get() {
		return _fVictory;
	}

	function _objectifCount_get() {
		
	}
	
//______________________________________________________________________________
//	Process
	
	function process() {
		// get all unit by player
			_init();
			
			var fDelta = 0;
			// get max 
			var iCountMax :Int = 0;
			var iChallengerIdNew :Int = null;
			for ( iPlayerId in _mObjectif.keys() ) {
				var iCount = _mObjectif.get( iPlayerId ).length;
				// Nobody win if ==
				if ( iCount == iCountMax ) {
					iChallengerIdNew = null;
					break;
				}
				if ( iCount > iCountMax) {
					iCountMax = iCount;
					iChallengerIdNew = iPlayerId;
				}
				
			}
			
			_victory_process( iChallengerIdNew );
			
			if ( _fVictory > 1 ) {
				_oGame.end( _oChallenger );
			}
	} 
	
	function _victory_process( iChallengerIdNew :Int ) {
		// Victory update
			// Init
			if ( _oChallenger == null ) {
				_oChallenger = _oGame.player_get( iChallengerIdNew );
				return;
			}
			// Challenger contested
			if ( _oChallenger.playerId_get() != iChallengerIdNew ) {
				if ( iChallengerIdNew == null )
					return;
				if ( _fVictory - 0.001 < 0 ) {
					_oChallenger = _oGame.player_get( iChallengerIdNew );
					return;
				} else {
					_fVictory -= 0.001;
					return;
				}
			} 
			// Same challenger
			else {
				_fVictory += 0.001;
				return;
			}
	}
	
//______________________________________________________________________________
//	Sub-routine

	function _influence_get() {
		// return quantity of city a player have
	}
	
	function _init() {
		_mObjectif = new IntMap<List<Unit>>();
		for ( oEntity in _oGame.entity_get_all() ) {
			var oLoyaltyShift =  oEntity.ability_get( LoyaltyShift );
			if ( oLoyaltyShift != null ) {
				//Assume only unit have this ability
				var oUnit :Unit = cast oEntity; 
				var oPlayer :Player = oUnit.owner_get();
				if ( oPlayer != null ) {
					if ( !_mObjectif.exists( oPlayer.playerId_get() ) )
						_mObjectif.set( 
							oPlayer.playerId_get(), 
							new List<Unit>() 
						);
					_mObjectif.get( oPlayer.playerId_get() ).add( oUnit );
				}
			}
		}
	}
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		// on loop
		if( oSource == _oGame.onLoop )
			process();
		
		// on new entity
		if ( oSource == _oGame.onEntityNew ) {
			//Todo
			//entity_add( cast oSource.event_get() );
		}
		
		// on unit change loyalty
		if ( oSource == _oGame.onEntityUpdate ) {
			if ( 
				Std.is( _oGame.onEntityUpdate.event_get(), Unit ) 
			) {
				//TODO: use a different marker than loyaltyshift
				var oLoyaltyShift = _oGame.onEntityUpdate.event_get().ability_get( LoyaltyShift );
				if ( oLoyaltyShift != null ) {
					
					var oUnit = oLoyaltyShift.unit_get();
					
					for ( lObjectif in _mObjectif )
						lObjectif.remove( oUnit );
					
					_mObjectif.get( oUnit.owner_get().playerId_get() ).add( oUnit );
				}
			}
		}
	
	}
}