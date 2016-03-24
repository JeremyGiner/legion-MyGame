package space.transformation;

import Math;
import space.ITransformation;


class RotateY implements ITransformation{

	private var _fAngle :Float;

//_____________________________________________________________________________
	
	public function new( fAngle :Float ){
		_fAngle = fAngle;
	}
	
//_____________________________________________________________________________

	public function transform( afMatrix :Array<Float>){
		//SRC : http://code.google.com/p/glmatrix/source/browse/glMatrix.js
		var s = Math.sin(_fAngle);
        var c = Math.cos(_fAngle);
       
        // Cache the afMatrixrix values (makes for huge speed increases!)
        var a00 = afMatrix[0], a01 = afMatrix[1], a02 = afMatrix[2], a03 = afMatrix[3];
        var a20 = afMatrix[8], a21 = afMatrix[9], a22 = afMatrix[10], a23 = afMatrix[11];

		// Perform axis-specific afMatrixrix multiplication
		afMatrix[0] = a00*c + a20*-s;
		afMatrix[1] = a01*c + a21*-s;
		afMatrix[2] = a02*c + a22*-s;
		afMatrix[3] = a03*c + a23*-s;

		afMatrix[8] = a00*s + a20*c;
		afMatrix[9] = a01*s + a21*c;
		afMatrix[10] = a02*s + a22*c;
		afMatrix[11] = a03*s + a23*c;

	}

}