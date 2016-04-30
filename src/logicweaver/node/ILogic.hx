package logicweaver.node;

/**
 * 
 * @author GINER Jérémy
 */
interface ILogic {

//_____________________________________________________________________________
//	Accessor
	/*
	public function clone()*/
	
	public function out_get() :Array<Float>;
	
	public function inResolution_get() :Int;
	public function outResolution_get() :Int;
	
//_____________________________________________________________________________
//	Modifier

	public function input_set( aValue :Array<Float> ) :Void;
	
//_____________________________________________________________________________
//	Process
	
	public function process() :Void;

	
}