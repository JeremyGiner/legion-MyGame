package mygame.spirit.genic;
import trigger.eventdispatcher.EventDispatcher;

/**
 * Entry point of a neural network variant
 * 
 * @author GINER Jérémy
 */
class OutNode extends Node {

	//var _oOutput :Node;
	//var _iOutputKey :Int;	// Key to be identified by the ouput neuron
	
	static var _oFunction :Array<Float>->Float = function(a :Array<Float>) :Float {
		return a[0];
	};
	
	var _fInputValue :Float;
	
	public var onUpdate :EventDispatcher;
	
//_____________________________________________________________________________
//	Constructor

	override public function new() {
		super();
		//_aInputValues = new Array<Float>();
		onUpdate = new EventDispatcher();
	}
	
//_____________________________________________________________________________
//	Accessor

	public function inputValue_set( f :Float ) {
		_fInputValue = f;
	}
//_____________________________________________________________________________
//

	override public function activate() :Void {
		throw('not implemented yet');
		
	}
}