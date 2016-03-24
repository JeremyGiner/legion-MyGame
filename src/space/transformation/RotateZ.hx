package space.transformation;

import Math;
import space.ITransformation;


class RotateZ implements ITransformation{

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
        var a10 = afMatrix[4], a11 = afMatrix[5], a12 = afMatrix[6], a13 = afMatrix[7];

		// Perform axis-specific afafMatrixrixrix multiplication
		afMatrix[0] = a00*c + a10*s;
        afMatrix[1] = a01*c + a11*s;
        afMatrix[2] = a02*c + a12*s;
        afMatrix[3] = a03*c + a13*s;
       
        afMatrix[4] = a00*-s + a10*c;
        afMatrix[5] = a01*-s + a11*c;
        afMatrix[6] = a02*-s + a12*c;
        afMatrix[7] = a03*-s + a13*c;

	}

}