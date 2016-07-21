package ob3updater;
import haxe.ds.StringMap;
import js.three.Matrix;
import js.three.Matrix4;
import js.three.Object3D;
import ob3updater.IOb3Updater;
import trigger.EventDispatcher2;

/**
 * ...
 * @author GINER Jérémy
 */
class Animation implements IOb3Updater {
	
	//var _aOb3Updater :Array<IOb3Updater>;
	
	var _oObj3 :Object3D;
	
	/**
	 * 
	 * Sorted by fKey asc
	 */
	var _aKeyFrame :Array<KeyFrame>;
	
	
	var _fDuration :Float;
	var _fTimeAlpha :Float;
	
	public var onEnd :EventDispatcher2<Animation>;
	
//_____________________________________________________________________________
//	
	public function new(
		oObject :Object3D,
		fDuration :Float,
		aKeyFrame :Array<KeyFrame>
	) {
		_oObj3 = oObject;
		
		_fTimeAlpha = _timeCurrent_get();
		///_aOb3Updater = new Array<IOb3Updater> ();
		_aKeyFrame = aKeyFrame;
		
		_fDuration = fDuration;
		
		onEnd = new EventDispatcher2<Animation>();
	}
//_____________________________________________________________________________
//	Accessor

	public function object3d_get() {
		return _oObj3;
	}
//_____________________________________________________________________________
//	
	
	public function update() {
		
		var fPercent = _timeIntervalPercent_get();
		
		if ( fPercent > 1.0 ) {
			onEnd.dispatch( this );
			return;
		}
		
		// Get boundary keyframes
		var a = _keyFrameBoundary_get( fPercent );
		var oKeyFramePrev = a[0]; 
		var oKeyFrameNext = a[1];
		
		// Get current frame (interpolate keyframes)
		var oFrame = _frameCurrent_get( oKeyFramePrev, oKeyFrameNext, fPercent );
		
		// Update obj3
		_applyChange( oFrame );
	}
//_____________________________________________________________________________
//	Sub-routine

	function _timeIntervalPercent_get() {
		return ( _timeCurrent_get() - _fTimeAlpha ) / _fDuration;
	}
	
	function _timeCurrent_get() {
		return Date.now().getTime();
	}
	
	function _keyFrameBoundary_get( fPercent :Float ) {
		for ( i in 0..._aKeyFrame.length ) {
			if( _aKeyFrame[i].fKey <= fPercent && _aKeyFrame[i+1].fKey >= fPercent )
				return [
					_aKeyFrame[i],
					_aKeyFrame[i+1]
				];
		}
		throw('wierd');
		return null;
	}

	function _frameCurrent_get( oKeyFramePrev :KeyFrame, oKeyFrameNext :KeyFrame, fPercent :Float ) {
		// Case : next keyframe is current keyframe
		if ( fPercent == oKeyFrameNext.fKey )
			return oKeyFrameNext;
		
		// Get percent between keyframe
		var fRatio = ( fPercent - oKeyFramePrev.fKey ) / (oKeyFrameNext.fKey - oKeyFramePrev.fKey);
		
		// Get interpolation of each field
		var mField = new StringMap<Dynamic>();
		for ( sFieldName in oKeyFrameNext.mField.keys() ) {
			
			var oValue :Dynamic = null;
			
			switch( sFieldName ) {
				case 'matrix' :
					// Matrix interpolation
					oValue = _matrix_interpolate( 
						oKeyFramePrev.mField.get( sFieldName ),
						oKeyFrameNext.mField.get( sFieldName ),
						fRatio 
					); 
				default :
					// Float interpolation
					oValue = _interpolate( 
						oKeyFramePrev.mField.get( sFieldName ),
						oKeyFrameNext.mField.get( sFieldName ),
						fRatio 
					); 
			}
			
			mField.set( sFieldName, oValue );
		}
		
		// Make current state
		return {
			fKey: fRatio,
			mField: mField
		}
	}
	
	function _applyChange( oFrame :KeyFrame ) {
		//
		var o = null;
		var sFieldName = '';
		for ( sFieldPath in oFrame.mField.keys() ) {
			o = _oObj3;
			var a = sFieldPath.split('.');
			a.reverse();
			while ( (sFieldName = a.pop()) != null ) {
				if ( a.length == 0 )
					Reflect.setField( o, sFieldName, oFrame.mField.get( sFieldPath ) );
				else
					o = Reflect.field( o, sFieldName );
			}
			
		}
		// Specific for matrix
		if ( oFrame.mField.exists('matrix') ) {
			_oObj3.matrixAutoUpdate = false;
			_oObj3.matrixWorldNeedsUpdate = true;
		}
	}
	
	
	function _interpolate( fAlpha :Float, fOmega :Float, fPercent :Float ) {
		return fAlpha + ( fOmega - fAlpha ) * fPercent;
	}
	
	function _matrix_interpolate( oAlpha :Matrix, oOmega :Matrix, fPercent :Float ) {
		var oMatrix = new Matrix4();
		for ( i in 0...oAlpha.elements.length )
			oMatrix.elements[i] = oAlpha.elements[i] + (oOmega.elements[i] - oAlpha.elements[i]) * fPercent;
		return oMatrix;
	}
	
	function _color_interpolate() {
		//TODO
	}
}

typedef KeyFrame = {
	var fKey :Float;
	var mField :StringMap<Dynamic>;
}