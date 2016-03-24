package space.transformation;

import space.ITransformation;

//SRC : http://code.google.com/p/glmatrix/source/browse/glMatrix.js
class Rotate implements ITransformation{
	private var _rx :Float;
	private var _ry :Float;
	private var _rz :Float;
	/*
	public function new( rx :Float, ry :Float, rz :Float, axis :Vector3){
		_rx = rx;
		_ry = ry;
		_rz = rz;
	}
	
	
	public function transform( afMatrix :Array<Float>){
	
		var cx = Math.cos(_rx)
		var sx = Math.sin(_rx);
		var cy = Math.cos(_ry), 
		var sy = Math.sin(_ry);
		var cz = Math.cos(_rz), 
		var sz = Math.sin(_rz);
		
		afMatrix[0] = cy*cz;
		afMatrix[1] = (sx*sy*cz-cx*sz);
		afMatrix[2] = (sx*sz+cx*sy*cz);
		
		afMatrix[4] = cy*sz;
		afMatrix[5] = (sx*sy*sz+cx*cz);
		afMatrix[6] = (cx*sy*sz-sx*cz);
		
		afMatrix[8] = -sy;
		afMatrix[9] = sx*cy;
		afMatrix[10] = cx*cy;
		
		/*
		  // Returns matrix
		  return new Float32Array([cy*cz, (sx*sy*cz-cx*sz), (sx*sz+cx*sy*cz), 0,
								   cy*sz, (sx*sy*sz+cx*cz), (cx*sy*sz-sx*cz), 0,
								   -sy,   sx*cy,            cx*cy,            0,
								   0,     0,                0,                1]);
	}*/


}