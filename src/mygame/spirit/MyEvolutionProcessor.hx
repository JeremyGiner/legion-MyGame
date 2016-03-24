package mygame.spirit;

import mygame.game.action.IAction;
import mygame.game.entity.Player;
import mygame.spirit.Spirit;
import mygame.game.MyGame;

/**
 * Mutate, test fitness and process result for a group of spirit
 * 
 * Mutation process
 * 	- take half of top fitted (kill the rest)
 * 	- clone each
 * 	- mutate cloning result
 * 
 * 
 * @author GINER Jérémy
 * 
 */

class MyEvolutionProcessor extends EvolutionProcessor<MySpirit> {

	var _iMutationQuantity :Int;	// Number of mutated children per spirit in one pass; Include in [1;++]
	
	var _iRunLimit :Int;	// Number of instruction a spirit can run between game loop
	
//_____________________________________________________________________________
// Constructor

	public function new() {
		super( _generation0_init(), null );
		
		
		_iMutationQuantity = 1;
		
		
	}
//_____________________________________________________________________________
//	Process

	override public function process() {
		
		// Mutate
		for ( oSpirit in _aSpirit ) {
			for ( i in 0..._iMutationQuantity ) {
				//_aSpirit.push( oSpirit.clone() );
				//_aSpirit.push( _oMutator.mutate( oSpirit.nodenet_get() ) );
			}
		}
		
		// Play a match
		_evironnement_run();
		
		// Selection
		_select();
		
	}

//_____________________________________________________________________________
//	Sub-routine

	function _evironnement_run() {
		
		// Init Spirit
		/*var aSpirit = new Array<MySpirit>();
		for ( oSpirit in _aSpirit )
			aSpirit.push( oSpirit.clone() );*/
		
		// Init score
		var aScore = new Array<Int>();
		for ( i in 0..._aSpirit.length ) {
			aScore[i] = 0;
		}
		
		// Init game
		var oEnvironnement = new MyGame();
		
		// Run game
		var oWinner :Player = null;
		while ( 
			oWinner != null ||
			oEnvironnement.loopId_get() < 40000/*~30 minute*/ 
		) {
			for ( i in 0..._aSpirit.length ) {
				var oSpirit = _aSpirit[i];
				
				for( i in 0..._iRunLimit ) {
					oSpirit.nodenet_get().process();
					for ( oMotor in oSpirit.motor_get_all() ) {
						
						// Try to get an action
						var oOut = oMotor.out_get();
						if ( oOut != null && Std.is( oOut, IAction ) ) {
							
							// Execute action
							var b = oEnvironnement.action_run( oOut );
							
							// Penalise invalid actions
							if ( b == false )
								aScore[i] -= 10;
						}
					}
				}
			}
			
			oEnvironnement.loop();
			
			// Reward winner
			for ( i in 0..._aSpirit.length ) {
				var oSpirit = _aSpirit[i];
				if ( oWinner == oSpirit.player_get() )
					aScore[i] += 1000;
			}
			
			// Reward second place ( case match timeout )
			oWinner = oEnvironnement.oVictoryCondition.challenger_get();
			for ( i in 0..._aSpirit.length ) {
				var oSpirit = _aSpirit[i];
				if ( oWinner == oSpirit )
					aScore[i] += 1000;
			}
		}
		
		// 
	}

	function _generation0_init() :Array<MySpirit> {
		throw('Not implemented yet');
		var aSpirit = new Array<MySpirit>();
		for ( i in 0..._iPopulationMax) {
			aSpirit.push( new MySpirit(null,null) );
		}
		return aSpirit;
	}

	override function _mutate( oSpirit ) :MySpirit {
		throw('not implemented yet');
		// Add node?
		// Remove node?
		return null;
	}
	
	 /**
	 * Sort a generation by the most to less fitted
	 */
	override function _fitness_sort( aSpirit :Array<MySpirit> ) {
		//todo Use fitness compare
	}
	
	function _fitness_compare( oSpiritA :Spirit, oSpiritB :Spirit ) :Spirit {
		throw('not implemented yet');
		// Compare game score
			// Score component :
				// Victory
				// Number of actions
				// Invalid action?
				// Game time?
		
		// Compare complexity
		
		// Compare 
		
		return null;
	}
	
	function _select() :Void {
		
		if( _aSpirit.length > _iPopulationMax ){
			// Dispose of excess
			//TODO
			while ( _aSpirit.length > _iPopulationMax ) {
				
				// DIspose of the last one
				var o = _aSpirit.pop();
				o.dipose();
			}
		}
	}
	
}