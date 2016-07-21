package ob3updater;
import js.three.Matrix4;
import js.three.Object3D;

/**
 * ...
 * @author GINER Jérémy
 */
class Transistion implements IOb3Updater {
	
	var _oObject3D :Object3D;
	
	var _iTimeAlpha :Int;
	var _oMatrixAlpha :Matrix4;
	var _oMatrixDelta :Matrix4;
	var _oMatrixOmega :Matrix4;
	
	var _iDuration :Int;
	var _oTimingFunction :Float->Float;
//_____________________________________________________________________________
//	Constructor
	
	public function new( oObject3D :Object3D, iDuration :Int ) {
		_iTimeAlpha =  null;
		_oTimingFunction = timeFuncLinear;
		
		_oObject3D = oObject3D;
		_oObject3D.matrixAutoUpdate = false;
		_oObject3D.updateMatrix();
		_iDuration = iDuration;
		
		_setup( _oObject3D.matrix );
	}

//_____________________________________________________________________________
//	Accessor

	public function object3d_get() {
		return _oObject3D;
	}

//_____________________________________________________________________________
//	
	
	public function update() {
		
		// Get new omega
		var oMatrixOmegaNew :Matrix4 = new Matrix4();
		oMatrixOmegaNew.compose( _oObject3D.position, _oObject3D.quaternion, _oObject3D.scale );
		
		// Case : end state reach
		if ( 
			oMatrixOmegaNew.equals( _oObject3D.matrix )
		) {
			_iTimeAlpha = null;
			return;
		}
		
		// Case : new setup required ( end state not reach and no current setup or new omega state )
		if ( 
			_iTimeAlpha == null ||
			!oMatrixOmegaNew.equals( _oMatrixOmega )
		) {
			_setup( oMatrixOmegaNew );
		}
		
		// Get updated matrix
		var oMatrixUpdated = _oMatrixAlpha.clone();
		
		var fTimePercent = Math.min( 1, _timeIntervalPercent_get());
		var fMult = _oTimingFunction( fTimePercent );
		for ( i in 0..._oMatrixDelta.elements.length )
			oMatrixUpdated.elements[i] = _oMatrixAlpha.elements[i] + _oMatrixDelta.elements[i] * fMult;
		
		// Update object with updated matrix
		_oObject3D.matrix = cast oMatrixUpdated;
		_oObject3D.matrixWorldNeedsUpdate = true;
		
		if ( fTimePercent >= 1 ) {
			_iTimeAlpha = null;
			_oObject3D.matrix = _oMatrixOmega;
			return;
		}
	}
	
//_____________________________________________________________________________
//	Sub-routine
	
	function _setup( oMatrixOmega :Matrix4) {
		// Save omega state
		_oMatrixOmega = oMatrixOmega;
		
		// Save alpha state
		_iTimeAlpha = Math.floor( _timeCurrent_get() );
		_oMatrixAlpha = cast _oObject3D.matrix;
		
		// Get matrix delta
		_oMatrixDelta = cast _oMatrixOmega.clone();
		for ( i in 0..._oMatrixDelta.elements.length )
			_oMatrixDelta.elements[i] = _oMatrixDelta.elements[i] - _oMatrixAlpha.elements[i];
	}
	
	function _timeCurrent_get() {
		return Date.now().getTime();
	}
	
	function _timeIntervalPercent_get() {
		return ( _timeCurrent_get() - _iTimeAlpha ) / _iDuration;
	}
	
//_____________________________________________________________________________
//	Utils

	static public function timeFuncLinear( f :Float ) {
		return f;
	}
}