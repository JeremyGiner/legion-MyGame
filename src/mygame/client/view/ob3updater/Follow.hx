package mygame.client.view.ob3updater;
import js.three.Euler;
import js.three.Matrix4;
import js.three.Object3D;
import js.three.Quaternion;
import js.three.Vector3;
import mygame.client.view.GameView;
import ob3updater.IOb3Updater;

/**
 * ...
 * @author GINER Jérémy
 */
class Follow implements IOb3Updater {
	
	var _oObject3D :Object3D;
	var _oObject3DFollowed :Object3D;
	
	
	var _oGameView :GameView;
	
//_____________________________________________________________________________
//	Constructor
	
	public function new( oGameView :GameView, oObject3D :Object3D, oObject3DFollowed :Object3D ) {
		
		_oObject3D = oObject3D;
		_oObject3D.matrixAutoUpdate = false;
		
		_oObject3DFollowed = oObject3DFollowed;
		_oGameView = oGameView;
	}

//_____________________________________________________________________________
//	Accessor

	public function object3d_get() {
		return _oObject3D;
	}
	
	public function gameView_get() {
		return _oGameView;
	}

//_____________________________________________________________________________
//	
	
	public function update() {
		
		var oMatrix = _orthoproject( _oObject3DFollowed );
		
		
		// Update gauge holder
		
		var v = new Vector3(0,0);
		var vDelta = new Vector3(1, 1);
		v.applyProjection( cast oMatrix );
		vDelta.applyProjection( cast oMatrix );
		
		
		var oMatrixUpdated = new Matrix4();
		oMatrixUpdated.compose(
			new Vector3( v.x, v.y, 0 ),
			new Quaternion(),
			new Vector3( 
				vDelta.x - v.x,
				Math.max( Math.min( vDelta.y - v.y, 0.01), 0.002 ),
				1)
		);
		
		// Update object with updated matrix
		_oObject3D.matrix = cast oMatrixUpdated;
		_oObject3D.matrixWorldNeedsUpdate = true;
		
		// 
		
	}
	
//_____________________________________________________________________________
//	Sub-routine

	function _orthoproject( oObj :Object3D ) {
		// Get camera
		var oCamera = gameView_get().camera_get();
		var oCameraOrtho = gameView_get().cameraOrtho_get();
		//TODO: use ortho camera for convertion
		
		// Update parents
		var up = oObj;
		while ( 
			up.parent != null && 
			up.parent.matrixWorldNeedsUpdate == true 
		) {
			up = up.parent;
		}
		up.updateMatrixWorld(true);
		
		// Get world matrix
		var oObjMatrixWorld = untyped oObj.matrixWorld;
		
		// Get camera inverse world matrix
		oCamera.updateMatrixWorld(true);
		oCamera.matrixWorldInverse.getInverse( untyped oCamera.matrixWorld );
		
		// Get matrices Obj -> Eye
		var oMatrix = new Matrix4();
		oMatrix.multiplyMatrices( oCamera.matrixWorldInverse, oObjMatrixWorld );
		oMatrix.multiplyMatrices( oCamera.projectionMatrix, oMatrix  );
		
		
		
		return oMatrix;
	}

}