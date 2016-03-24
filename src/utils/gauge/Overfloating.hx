package utils.gauge;

import utils.gauge.Gauge;

class Overfloating extends Gauge {
	private var _fCurrent :Float;
	private var _fMax :Float;
	
//______________________________________________________________________________
//	Accessor

	override public function current_set( fCurrent :Float ):Void{ 
		_fCurrent = fCurrent % _fMax;
	}
}