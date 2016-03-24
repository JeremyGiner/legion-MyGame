package mygame.spirit;


/**
 * Mutate, test fitness and process result for a group of CSpirit
 * @author GINER Jérémy
 */

class EvolutionProcessor<CSpirit:Spirit> {

	var _aSpirit :Array<CSpirit>;
	var _oMutator :Mutator<Dynamic>;
	
	var _iGenId :Int;
	
	var _iPopulationMax :Int;
	//var _iPopulationMin :Int;
	
//_____________________________________________________________________________
// Constructor

	function new( aCSpirit :Array<CSpirit>, oMutator :Mutator<Dynamic> ) {
		_aCSpirit = aCSpirit;
		_oMutator = oMutator;
		_iGenId = 0;
		
		_iPopulationMax = 10;
	}
	
//_____________________________________________________________________________
//	Accessor

	public function generation_get() { return _iGenId; }

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
	function _fitness_sort( aCSpirit :Array<CSpirit> ) {
		throw('This is an abstract function');
	}

	function _mutate( oCSpirit ) :CSpirit {
		throw('This is an abstract function');
		return null;
	}
	
	function _fitness_get( oCSpirit ) :Float {
		throw('This is an abstract function');
		return 0;
	}
	
}