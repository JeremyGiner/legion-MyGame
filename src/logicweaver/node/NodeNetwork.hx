package logicweaver.node;

/**
 * Neural network variant
 * @author GINER Jérémy
 */
class NodeNetwork {

	var _lNode :List<Node>;
	
	var _aInNode :Array<InNode>;
	var _aOutNode :Array<OutNode>;
	
	var _lNodeActive :List<INode>;
	
//_____________________________________________________________________________
//	Constructor

	public function new( iInputQuantity :Int, iOutQuantity :Int, oComplexity :Int ) {
		_lNode = new List<Node>();
		
		_aInNode = new Array<InNode>();
		for( i in 0...iInputQuantity ) {
			_aInNode.push( new InNode() );
		}
		
		_aOutNode = new Array<OutNode>();
		for( i in 0...iOutQuantity ) {
			_aOutNode.push( new OutNode() );
		}
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function clone() {
		
		throw('not implemented yet');
		
		var oClone = Type.createEmptyInstance( Type.getClass( this ) );
		
		for( oNode in _lNode ) 
			oClone._lNode.push( oNode.clone() );
		
		return oClone;
	}
	
	public function outNodeArray_get() {
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
		for( i in 0...aValue.length )
			_aInNode[i].inputValue_set( aValue[i] );
		
	}
	
	public function connection_add( iNodeSource :Node, iNodeDestination :Node ) {
		// Check source is not InNode
		if ( Std.is( iNodeSource, InNode )  )
			throw( 'invalid source node' );
			
		// Add connection
		//TODO
	}
	public function connection_add_byIndex( iNodeSourceIndex :Int, iNodeDestinationIndex :Int ) {
		//TODO
	}
	
//_____________________________________________________________________________
//	Process
	
	public function process() {
		
		// Process first node
		var oNode = _lNodeActive.pop();
		oNode.activate();
		
		// Pile up his output node
		// check if not already activate
		if( oNode != null )
			_lNodeActive.add( null );//TODO 
		
		// Check if not brain-dead
		if( _lNodeActive.isEmpty() )
			trace('[WARNING]:BRAINDEAD');
	}
	
	public function boot() {
		
	}
//_____________________________________________________________________________
//	Temporary solutions

	public function mutation( iMutationQ :Int ) {
		//TODO
		
		// Get x Node with least activited count
		
		//...
	}


//_____________________________________________________________________________
//	Utils

	static public function create( iInputQuantity :Int, iOutQuantity :Int, oComplexity :Int ) {
		
	}
	
}