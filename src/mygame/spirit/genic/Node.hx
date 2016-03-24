package mygame.spirit.genic;

/**
 * Basic component of a neural network variant
 * @author GINER Jérémy
 */

class Node implements INode {

	var _oOutput :Node;
	var _iOutputKey :Int;	// Key to be identified by the ouput neuron
	
	var _aOutNode :Array<Node>;
	var _aInNode :Array<Node>;
	
	var _aParam :Array<Float>;	// Personal parameters
	
	var _fValue :Float;	//last updated value
	
	var _bActivated :Bool;	//Activation flag
	
	static var _oFunction :Array<Float>->Float = function(a :Array<Float>) :Float {
		
		var v :Float = 0;
		
		for ( f in a ) {
			v += f;
		}
		v = 1 / ( 1 + Math.pow(2.71828, v) );
		
		return a[0];
	};
	
//_____________________________________________________________________________
//	Constructor

	public function new() {
		_iOutputKey = null;
		
		_aOutNode = new Array<Node>();
		_aInNode = new Array<Node>();
	}
	
	public function clone() :Node {
		var o = new Node();
		return o;
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function value_get() {
		return _fValue;
	}

	public function output_get() {
		return _oOutput;
	}
	/*
	public function child_add( oNode :Node ) {
		oNode._iOutputKey = _aInput.length;
		_aInput[ _aInput.length ] = oNode;
		oNode._oOutput = this;
	}*/

//_____________________________________________________________________________
// 

	public function activate() :Void {
		
		// Convert array of node into array of Float
		var a = new Array<Float>();
		for ( oNode in _aInNode )
			a.push( oNode.value_get() );
		
		// Update value
		_fValue = _oFunction( a );
	}
//_____________________________________________________________________________
//	Functor

	static function thresholdClassic( a :Array<Float> ) :Float {
		
		var v :Float = 0;
		
		for ( f in a ) {
			v += f;
		}
		v = 1 / ( 1 + Math.pow(2.71828, v) );
		
		return v;
	};
	
	static function mult( a :Array<Float> ) :Float {
		
		var v :Float = 0;
		
		for ( f in a ) {
			v += f;
		}
		v = 1 / ( 1 + Math.pow(2.71828, v) );
		
		return v;
	};
/*
 * http://www.pastraiser.com/cpu/gameboy/gameboy_opcodes.html
OPCODE
RS source register
RT destination
I	immediate value

Arithmetic 
	add
	sub
	mul
	div
	mod
	inc
	dec
Conditional/jump
	jump to
	jump if = 0
	
*/
}
