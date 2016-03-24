package utils.gauge;

class Gauge {
	private var _fCurrent :Float;
	private var _fMax :Float;
	
//______________________________________________________________________________
//	Accessor

	public function current_set( fCurrent :Float ):Void{ 
		_fCurrent = Math.min( Math.max( fCurrent, _fMax), 0);
		//TODO : event change 
	}
	public function current_get():Float{ return _fCurrent; };
	
	public function max_set( fMax :Float ):Void{
		_fMax = fMax;
		//TODO : event change max 
	}
	public function max_get():Float{
		return _fMax;
	}

//______________________________________________________________________________
//	Shortcut

	public function percent_set( fPercent :Float ):Void{
		current_set( fPercent*_fMax );
	}
	public function percent_get():Float{
		return _fCurrent/_fMax;
	}
}