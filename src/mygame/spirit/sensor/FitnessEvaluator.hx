package mygame.spirit;

/**
 * Evaluate the fitness of a spirit at a particular task
 * @author GINER Jérémy
 */

class FitnessEvaluator<CTask,CSpirit:Spirit> {
	
	var _oTask :CTask;
	var _oSpirit :CSpirit;
	
//_____________________________________________________________________________
// Constructor

	function new( oTask :CTask ) {
		_oTask = oTask;
		_oSpirit = oSpirit;
	}
	
//_____________________________________________________________________________
// Utils

	static public function evaluation_get( oTask :CTask, oSpirit :CSpirit ) :Int {
		
	}
	
	
}