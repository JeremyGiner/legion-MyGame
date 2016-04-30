package logicweaver_gigablaster;

import haxe.ds.IntMap;
import cloner.Cloner;
import haxe.ds.StringMap;
import haxe.Serializer;
import logicweaver.node.NodeNetASMLike;
import logicweaver_gigablaster.GigaEntity;
import logicweaver.EvolutionProcessor;
import haxe.ds.ArraySort;
import sys.io.File;
import utils.ArrayTool;
import utils.MapTool;

/**
 * Mutate, test fitness and process result for a group of Entity
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

class GigaEvolutionProcessor extends EvolutionProcessor<GigaEntity> {
	
	static public var _aScoreCache = new StringMap<Array<Int>>();
	
//_____________________________________________________________________________
// Constructor

	public function new() {
		super( null );
		
		_mEntity = _generation0_init(5);
		_iPopulationMax = 3;
		_iRunLimit = 20;
		_iMutationQuantity = 2;
		
		
		Sys.println( 'INit ok' );
	}
//_____________________________________________________________________________
//	Accessor

	
//_____________________________________________________________________________
//	Process

	override public function process() {
		super.process();
		
		// fitness sort
		var aScore = _fitness();
		
		// Selection
		_select( aScore );
		
		// Mutate
		// create more random
		_mEntity = MapTool.getMergedIntMap( _mEntity, _generation0_init( _iMutationQuantity ) );
		/*for ( oEntity in _mEntity ) {
			for ( i in 0..._iMutationQuantity ) {
				//_mEntity.push( oEntity.clone() );
				//_mEntity.push( _oMutator.mutate( oEntity.nodenet_get() ) );
			}
		}*/
		
		
		// Save (every 1000 gen)
		if ( generation_get() % 10 == 0 ) {
			Sys.println('Saving...');
			var oSerilizer = new Serializer();
			oSerilizer.useCache = true;
			oSerilizer.serialize(this);
			File.saveContent( 'gen', oSerilizer.toString() );
		}
	}

//_____________________________________________________________________________
//	Sub-routine

	/**
	 * Sort ntity for the top score to the lowest
	 * @return array of entity id sorted form the fitest to the worst
	 */
	function _fitness() {
		
		Sys.println( '---- fitness GEN '+_iGenId+' ----' );
		
		// Init Entity
		/*var aEntity = new Array<MyEntity>();
		for ( oEntity in _mEntity )
			aEntity.push( oEntity.clone() );*/
		
		// Init score
		/**
		 * entity id => [
		 * 	0 => entity id, 
		 * 	1 => score
		 * ]
		 */
		var mScore = new IntMap<Array<Int>>();
		for ( oEntity in _mEntity ) {
			mScore.set( oEntity.id_get() ,[ oEntity.id_get(), 0 ] );
		}
		
		// Pair entity 
		var aEntity :List<GigaEntity> = MapTool.toList( _mEntity );//copy();
		while ( aEntity.length != 0 ) {
			var oEntity0 = aEntity.pop();
			for ( oEntity1 in aEntity ) {
				// Add score for this match
				var aResult = _score_get( oEntity0, oEntity1 );
				mScore.get( oEntity0.id_get() )[1] += aResult[0];
				mScore.get( oEntity1.id_get() )[1] += aResult[1];
			}
		}
		
		// Sort entity by score
			// Convert score map into score array 
			//(since map can't be sorted and we no longer need the access by entity id )
			var aScore = [];
			for( a in mScore )
				aScore.push( a );
		
			// Sort score array from best to worst
			ArraySort.sort( aScore, 
				function( a1 :Array<Int>, a2 :Array<Int> ) {
					return  a2[1] - a1[1];
				}
			);

			// Format score
			var aTmp = new Array<Int>();
			for ( a in aScore ) {
				//DEBUG
				Sys.println( 'Entity : #' + a[0] + '; score: ' + a[1] );
				aTmp.push( a[0] );
			}
			
		
		return aTmp;
	}

	/**
	 * 
	 * @return
	 */
	function _generation0_init( iQuantity :Int ) :IntMap<GigaEntity> {
		
		var mEntity = new IntMap<GigaEntity>();
		for ( i in 0...iQuantity) {
			var id = _entityId_generate();
			mEntity.set( id, new GigaEntity(
				id, //Id
				'gen0',
				new NodeNetASMLike( 18, 4, 100 )
			) );
		}
		return mEntity;
	}

	override function _mutate( oEntity ) :GigaEntity {
		throw('not implemented yet');
		// Add node?
		// Remove node?
		return null;
	}
	
	 /**
	 * Sort a generation by the most to less fitted
	 */
	override function _fitness_sort( aEntity :Array<GigaEntity> ) {
		//todo Use fitness compare
	}
	
	function _fitness_compare( oEntityA :GigaEntity, oEntityB :GigaEntity ) :GigaEntity {
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
	
	function _select( aScore :Array<Int> ) {
		
		// Get population execess
		aScore = aScore.slice( _iPopulationMax );
		
		// Kill excedent
		for ( iId in aScore ) {
			_mEntity.remove( iId );
		}
	}
	
	function _score_get( oEntity0 :GigaEntity, oEntity1 :GigaEntity ) {
		
		//Sys.println('Judging E#' + oEntity0.id_get() + ' against E#' + oEntity1.id_get() );
		
		// Cache load atttempt
		if ( 
			_aScoreCache.exists( oEntity0.id_get() + ';' + oEntity1.id_get() ) 
		) {
			//Sys.println('cache' );
			return _aScoreCache.get( oEntity0.id_get() + ';' + oEntity1.id_get() );
		}
		
		//
		var aScore = [ 0, 0 ];
		
		var oGame :Dynamic = untyped __call__('new grid0\\Game', null);
		var oCloner = new Cloner();
		oEntity0 = oCloner.clone( oEntity0 );
		oEntity1 = oCloner.clone( oEntity1 );
		
		// Set context
		oEntity0.context_set( oGame, 0 );	// set as player 0
		oEntity1.context_set( oGame, 1 );	// set as player 1
		
		// Run game
		var oWinner = null;
		while ( oWinner == null ) {
			
			// Process entity 0 for this turn
			var aInput0 :Dynamic = null;
			var oGameInput0 = new IntMap<String>();
			var i = 0;
			while ( 
				(
					aInput0[ 0 /*Endturn*/] == null ||  
					aInput0[ 0 /*Endturn*/] == false 
				) && 
				i++ < _iRunLimit ) {
				aInput0 = oEntity0.process();
				if( aInput0[1/*UnitOrder*/] != null )
					oGameInput0 = utils.MapTool.getMergedIntMap( oGameInput0, aInput0[1/*UnitOrder*/] );
			}
			
			// Case overdue
			if ( i == _iRunLimit+1 )
				aScore[ 0 ] -= 1;	
			
			// Process entity 1 for this turn
			var aInput1 :Dynamic = null;
			var oGameInput1 = new IntMap<String>();
			i = 0;
			while ( 
				(
					aInput1[ 0 /*Endturn*/] == null ||  
					aInput1[ 0 /*Endturn*/] == false 
				) && 
				i++ < _iRunLimit 
			) {
				aInput1 = oEntity1.process();
				if( aInput1[1/*UnitOrder*/] != null )
					oGameInput1 = utils.MapTool.getMergedIntMap( oGameInput1, aInput1[1/*UnitOrder*/] );
			}
			// Case overdue
			if ( i == _iRunLimit+1 )
				aScore[ 1 ] -= 1;	
			
			// Feed the game input
			oGame.setInput( oGame.getContext(0), oGameInput0 );
			oGame.setInput( oGame.getContext(1), oGameInput1 );
			
			//Process game
			if ( oGame.process() == false )
				throw('the game did not process as expected, invalid input?');
			
			oWinner = oGame.getResult();
		}
		
		// Victory score
		if ( oWinner == oGame.getContext(0) )
			aScore[ 0 ] += 10000;
		if ( oWinner == oGame.getContext(1) )	//else
			aScore[ 1 ] += 10000;
		
		// update cache
		_aScoreCache.set( oEntity0.id_get() + ';' + oEntity1.id_get(), aScore );
			
		//
		return aScore;
	}
	
	
}