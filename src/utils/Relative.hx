package utils;

/**
 * Relative refenrence
 * @author GINER Jérémy
 */
!//TODO: finish
class Relative<CType,CKey> {
	
	var _bUpToDate :Bool;
	var _oBuffer :CType;

//_____________________________________________________________________________
//	Constructor
	
	public function new( CKey->CType ) { 
		_bUpToDate = false;
		_oBuffer = null;
	} 

//_____________________________________________________________________________
//	Accessor

	public function obsolete(){ _bUpToDate = false; return this; }
	public function get() :CType { 
		if ( !_bUpToDate ) 
			_update();
		
		return _oBuffer;
	}
	
//_____________________________________________________________________________
//	Utils
	
	function _update() {
		//TODO: update value, but how?
		_bUpToDate = true;
	}
}