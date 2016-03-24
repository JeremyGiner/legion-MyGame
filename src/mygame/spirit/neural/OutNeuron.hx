package mygame.spirit;

/**
 * Entry point of a neural network variant
 * @author GINER Jérémy
 */

class EntryNeuron {

	var _oOutput :Neuron;
	var _iOutputKey :Int;	// Key to be identified by the ouput neuron
	
	static var _oFunction :Array<Float>->Float = function(a :Array<Float>) :Float {
		return a[0];
	};
	
	var _fInputValue :Float;
	
//_____________________________________________________________________________
// Constructor

	override public function new() {
		_aInputValues = new Array<Float>();
	}
	
//_____________________________________________________________________________
//	Accessor

	public function inputValue_set( f :Float ) {
		_fInputValue = f;
	}
//_____________________________________________________________________________
//
	public function receive( iKey :Int, fValue :Float ) :Void {
		_aInputValues[ iKey ] = fValue;
	}

	public function send() :Void {
		_oOutput.receive( 
			_iOutputKey,
			_oFunction( new Array<Float>().push( _fInputValue ) )
		);
	}
}