package logicweaver.node;
import utils.IntTool;

/**
 * Neural network variant
 * @author GINER Jérémy
 */
class NodeNetASMLike implements ILogic {
	
	var _aInNode :Array<Float>;
	var _iInNodeP :Int;
	
	var _aOutNode :Array<Float>;
	var _iOutNodeP :Int;
	
	var _aInstruction :Array<Int>;
	var _iInstructionP :Int;
	
	var _aData :Array<Float>;
	var _iDataP :Int;	// pointer for data array
	
//_____________________________________________________________________________
//	Constructor

	public function new( iInputQuantity :Int, iOutQuantity :Int, iComplexity :Int ) {
		trace('generating NodeNet');
		_aInstruction = new Array<Int>();
		_iInstructionP = 0;
		
		_aData = [0.0];
		_iDataP = 0;
		
		_iInNodeP = 0;
		_iOutNodeP = 0;
		
		_aInNode = new Array<Float>();
		for( i in 0...iInputQuantity ) {
			_aInNode.push( null );
		}
		
		_aOutNode = new Array<Float>();
		for( i in 0...iOutQuantity ) {
			_aOutNode.push( null );
		}
		
		for ( i in 0...iComplexity ) {
			_aInstruction[i] = Math.floor( Math.random()*100 ) % 12; /*random in [0;11]*/
		}
		
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function out_get() {
		return _aOutNode;
	}
	
	public function inResolution_get() {
		return _aInNode.length;
	}
	public function outResolution_get() {
		return _aOutNode.length;
	}
	
//_____________________________________________________________________________
//	Modifier

	public function input_set( aValue :Array<Float> ) {
		
		// Check length
		if ( aValue.length != _aInNode.length )
			throw('[ERROR]:neunet.input_set:invalid input length');
		
		// Set entry Node
		_aInNode = aValue;
		
	}
	
//_____________________________________________________________________________
//	Process
	
	public function process() {
		
		_exec( _aInstruction[ _iInstructionP ] );
	}
	
//_____________________________________________________________________________
//	Temporary solutions

	public function mutation( iMutationQ :Int ) {
		//TODO
		
		// Get x Node with least activited count
		
		//...
	}


//_____________________________________________________________________________
//	Sub-routine

	function _exec( iInstruction :Int ) {
		// Instruction pointer modifier
		switch( iInstruction ) {
			case 0 : /*GOTO*/
				_iInstructionP = Math.floor( _aData[0] );
			case 1 : /*CJUMP*/
				if ( _aData[ _iDataP ] == 0 )
					_iInstructionP = Math.floor( _aData[0] );
			default : 
				_iInstructionP++;
		}
		
		// 
		if ( _iInstructionP < 0 || _iInstructionP >= _aInstruction.length )
			_iInstructionP = 0;
		
		//
		switch( iInstruction ) {
			
			case 2 : /*INC*/
				_aData[ _iDataP ]++;
				if ( _aData[ _iDataP ] == null )
					_aData[ _iDataP ] = 0;
			case 3 : /*DEC*/
				_aData[ _iDataP ]--;
			
			case 4 : /*MOVP*/
				_iDataP++;
				_dataValue_update();
			case 5 : /*MOVP*/
				_iDataP = IntTool.max( 0, _iDataP - 1 );
				_dataValue_update();
			
			case 6 : /*INP-*/
				_iInNodeP = IntTool.max( 0, _iInNodeP - 1 );
			case 7 : /*INP+*/
				_iInNodeP = IntTool.min( _aInNode.length, _iInNodeP + 1 );
			
			case 8 : /*OUTP-*/
				_iOutNodeP = IntTool.max( 0, _iOutNodeP - 1 );
			case 9 : /*OUTP+*/
				_iOutNodeP = IntTool.min( _aOutNode.length, _iOutNodeP + 1 );
			
			case 10 : /*MOVE IN*/
				_aData[ _iDataP ] = _aInNode[ _iInNodeP ];
			case 11 : /*MOVE OUT*/
				_aOutNode[ _iOutNodeP ] = _aData[ _iDataP ];
		}
	}
	
	/**
	 * Put data value into outNode
	 */
	function _dataValue_update() {
		if ( _aData[ _iDataP ] == null )
			_aData[ _iDataP ] = 0;
	}
	
//_____________________________________________________________________________
//	Debug

	public function print() {
		var s = '';
		for ( i in _aInstruction )
			s += i + ',';
		trace(s);
	}
}
