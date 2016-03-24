package mygame.spirit;

/**
 * Basic component of a neural network variant
 * @author GINER Jérémy
 */

class Neuron {

	var _oOutneuron :Neuron;
	var _iOutputKey :Int;	// Key to be identified by the ouput neuron
	
	var _aInput :Array<Neuron>;
	var _aInputValues :Array<Float>;
	
	static var _oFunction :Array<Float>->Float = function(a :Array<Float>) :Float {
		return a[0];
	};
	
	
//_____________________________________________________________________________
//	Constructor

	override public function new() {
		_aInputValues = new Array<Float>();
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function outneuron_get() {
		return _oOutneuron;
	}

//_____________________________________________________________________________
// 
	
	public function receive( iKey :Int, fValue :Float ) :Void {
		_aInputValues[ iKey ] = fValue;
	}

	public function send() :Void {
		_oOutneuron.receive( 
			_iOutputKey,
			_oFunction( _aInputValues )
		);
	}
}