package mygame.spirit.neural;

/**
 * Neural network variant
 * @author GINER Jérémy
 */

class NeuNet {

	var _lNeuron :List<Neuron>;
	
	var _aEntryNeuron :Array < EntryNeuron >;
	var _aOutNeuron :Array<OutNeuron>;
	
	var _lNeuronActive :List<Neuron>;
	
//_____________________________________________________________________________
//	Constructor

	public function new( iEntyQuantity :Int, iExitQuantity :Int ) {
		_aEntryNeuron = new Array<InNode>();
		for( i in 0...iEntyQuantity ) {
			_aEntryNeuron.push( new InNode() );
		}
		
		_aOutNeuron = new Array<InNode>();
		for( i in 0...iExitQuantity ) {
			_aOutNeuron.push( new OutNeuron() );
		}
	}
	
//_____________________________________________________________________________
//	Accessor
	


//_____________________________________________________________________________
// 
	
	public function input_set( aValue :Array<Float> ) {
		
		// Check length
		if ( aValue.length != _aEntryNeuron.length )
			throw('[ERROR]:neunet.input_set:invalid input length');
		
		// Set entry neuron
		for( i in 0...aValue.length )
			_aEntryNeuron[i].inputValue_set( aValue[i] );
		
		// Init entry by activating them
		for ( oNeuron in _aEntryNeuron ) {
			_lNeuronActive.push( _aEntryNeuron );
		}
	}

	public function process() {
		
		// Process
		var lNeuronNext = new List<Neuron>();
		for ( oNeuron in _lNeuronActive ) {
			
			// Send ouput to outneuron
			oNeuron.send();
			
			// Register out neuron
			var oOutneuron = oNeuron.outneuron_get()
			if( oOutneuron != null )
			lNeuronNext.push( oOutneuron );
		}
		
		// Swap current list of active neuron with the next
		_lNeuronActive = lNeuronNext;
		
		// Check if not brain-dead
		if ( _lNeuronActive.isEmpty() )
			trace('[WARNING]:BRAINDEAD');
	}
	
	public function mutation( iMutationQ :Int ) {
		//TODO
		
		// Get x neuron with least activited count
		
		//...
	}
}