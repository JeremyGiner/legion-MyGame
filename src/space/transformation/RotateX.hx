package space.transformation;

import Math;
import space.ITransformation;


class RotateX implements ITransformation{

	private var _fAngle :Float;

//_____________________________________________________________________________
	
	public function new( fAngle :Float ){
		_fAngle = fAngle;
	}
	
//_____________________________________________________________________________

	public function transform( oMatrix :Matrix4 ){
		oMatrix.rotateX( _fAngle );
	}

}