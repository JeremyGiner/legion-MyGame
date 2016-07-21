package mygame.game.process;

import haxe.ds.IntMap;
import legion.entity.Entity;
import mygame.game.MyGame;
import mygame.game.ability.Weapon;
import mygame.game.entity.Unit;
import mygame.game.entity.Player;
import mygame.game.ability.LoyaltyShift;
import mygame.game.query.EntityQuery;
import mygame.game.query.ValidatorEntity;
import utils.MapTool;

import trigger.*;

/**
 * WIP
 */
class VictoryCondition implements ITrigger {

	var _oGame :MyGame;
	
	var _fVictory :Float; //Percent
	var _oChallenger :Player;	//TODO: use team
	
	var _mObjectif :IntMap<List<Unit>>;	// Objectif unit indexed by player id
	
	var _mQueryCity :IntMap<EntityQuery>;

//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame ) {
		_oGame = oGame;
		
		_fVictory = 0;
		_oChallenger = null;
		_mQueryCity = new IntMap<EntityQuery>();
		
		// TODO : per army(team) instead of player
		for ( oPlayer in _oGame.player_get_all() ) {
			_mQueryCity.set( 
				oPlayer.playerId_get(),
				new EntityQuery( _oGame, new ValidatorEntity( [ 'ability' => LoyaltyShift, 'player' => oPlayer ] ) )
			);
		}
		
		//
		_oGame.onLoop.attach( this );
		
	}
	
//______________________________________________________________________________
//	Accessor
	
	public function challenger_get() {
		return _oChallenger;
	}
	
	public function value_get() {
		return _fVictory;
	}
	
//______________________________________________________________________________
//	Process
	
	function process() {
		
		_victory_process( _playerIdTop_get() );
		
		// Case : game end
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

	function _playerIdTop_get() {
		var iCountTop :Int = 0;
		var iPlayerIdTop :Int = null;
		
		// Search for top player
		for ( oPlayer in _oGame.player_get_all() ) {
			
			// Get player id
			var iPlayerId = oPlayer.identity_get();
			
			// Get count
			var iCount = MapTool.getLength( _mQueryCity.get( iPlayerId ).data_get(null) );
			
			// Case : draw
			if ( iCount == iCountTop ) {
				iPlayerIdTop = null;
			}
			
			// Case : new top found
			if ( iCount > iCountTop ) {
				iCountTop = iCount;
				iPlayerIdTop = iPlayerId;
			}
		}
		
		return iPlayerIdTop;
	}
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		// on loop
		if( oSource == _oGame.onLoop )
			process();
	
	}
}