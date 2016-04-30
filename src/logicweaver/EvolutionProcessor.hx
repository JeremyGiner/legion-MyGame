package logicweaver;

import haxe.ds.IntMap;
import logicweaver.entity.Entity;

/**
 * Mutate, test fitness and process result for a group of CEntity
 * @author GINER Jérémy
 */

class EvolutionProcessor<CEntity:Entity> {

	/**
	 * Used to generate id for entities
	 */
	var _iEntityIdGenerator :Int;
	
	/**
	 * Indexed by ID
	 */
	var _mEntity :IntMap<CEntity>;	
	//var _oMutator :Mutator<Dynamic>;
	
	/**
	 * Current generation number
	 */
	var _iGenId :Int;
	
	var _iPopulationMax :Int;
	//var _iPopulationMin :Int;

	/**
	 * Number of instruction a Entity can run between game loop
	 */
	var _iRunLimit :Int;
	
	/**
	 * Number of mutated children per Entity in one pass; Include in [1;++]
	 */
	var _iMutationQuantity :Int; 
	
//_____________________________________________________________________________
// Constructor

	function new( aCEntity :IntMap<CEntity> ) {
		_mEntity = aCEntity;
		
		_iGenId = 0;
		_iEntityIdGenerator = 0;
		
		_iPopulationMax = 10;	// the actual max pop is iPopulationMax + iMutationQuantity
		_iRunLimit = 1000;
		_iMutationQuantity = 5;
	}
	
//_____________________________________________________________________________
//	Accessor

	public function generation_get() { 
		return _iGenId; 
	}

//_____________________________________________________________________________
//	Process

	public function process() {
		_iGenId ++;
	}
//_____________________________________________________________________________
// 
	/**
	 * Sort a generation by the most to less fitted
	 */
	function _fitness_sort( aCEntity :Array<CEntity> ) {
		throw('This is an abstract function');
	}

	function _mutate( oCEntity ) :CEntity {
		throw('This is an abstract function');
		return null;
	}
	
	function _fitness_get( oCEntity ) :Float {
		throw('This is an abstract function');
		return 0;
	}
	
	function _entityId_generate() {
		return _iEntityIdGenerator++;
	}
	
}