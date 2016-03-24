package mygame.spirit.genic;

/**
 * Entry point of a neural network variant
 * @author GINER Jérémy
 */

class InNode implements INode {

	var _oOutput :Node;
	var _iOutputKey :Int;	// Key to be identified by the ouput neuron
	
	static var _oFunction :Array<Float>->Float = function(a :Array<Float>) :Float {
		return a[0];
	};
	
	var _fInputValue :Float;
	
//_____________________________________________________________________________
// Constructor

	public function new() {
	}
	
//_____________________________________________________________________________
//	Accessor

	public function inputValue_set( f :Float ) {
		_fInputValue = f;
	}
//_____________________________________________________________________________
//

	public function activate() :Void {
		
		// Update value
		
		// Update output list
	}
}