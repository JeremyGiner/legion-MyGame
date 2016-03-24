package space;

import space.IMatrix;
import Math;

class Matrix4 implements IMatrix {

	private static var _oIdentity :Matrix4 = null;
	
	private var _afMatrix :Array<Float>;
	/*
		0	4	8	12
		1	5	9	13
		2	6	10	14
		3	7	11	15
	*/

//_____________________________________________________________________________
//	Constructor

	public function new(
		a0 :Float = 1,
		a1 :Float = 0,
		a2 :Float = 0,
		a3 :Float = 0,
		
		a4 :Float = 0,
		a5 :Float = 1,
		a6 :Float = 0,
		a7 :Float = 0,
		
		a8 :Float = 0,
		a9 :Float = 0,
		a10 :Float = 1,
		a11 :Float = 0,
		
		a12 :Float = 0,
		a13 :Float = 0,
		a14 :Float = 0,
		a15 :Float = 1
	){
		_afMatrix = new Array<Float>();
		_afMatrix[0] = a0;
		_afMatrix[1] = a1;
		_afMatrix[2] = a2;
		_afMatrix[3] = a3;
		_afMatrix[4] = a4;
		_afMatrix[5] = a5;
		_afMatrix[6] = a6;
		_afMatrix[7] = a7;
		_afMatrix[8] = a8;
		_afMatrix[9] = a9;
		_afMatrix[10] = a10;
		_afMatrix[11] = a11;
		_afMatrix[12] = a12;
		_afMatrix[13] = a13;
		_afMatrix[14] = a14;
		_afMatrix[15] = a15;
	}

	public function clone(){
		return new Matrix4(
			_afMatrix[0],
			_afMatrix[1],
			_afMatrix[2],
			_afMatrix[3],
			_afMatrix[4],
			_afMatrix[5],
			_afMatrix[6],
			_afMatrix[7],
			_afMatrix[8],
			_afMatrix[9],
			_afMatrix[10],
			_afMatrix[11],
			_afMatrix[12],
			_afMatrix[13],
			_afMatrix[14],
			_afMatrix[15]
		);
	}
	
	public function copy( oMatrix :IMatrix){
		for( i in 0...15){
			this.set( i, oMatrix.get(i));
		}
		
		return this;
	}
	
//_____________________________________________________________________________
//	Accessor

	public function get( i :Int ){ return _afMatrix[i]; }
	
	public function set( i :Int, f :Float ){
		_afMatrix[i] = f;
		return this;
	}

//_____________________________________________________________________________
//	Transform

	//SRC : http://code.google.com/p/glmatrix/source/browse/glMatrix.js
	public function translation_add( tx :Float, ty :Float, tz :Float ){
		_afMatrix[12] = _afMatrix[0]*tx + _afMatrix[4]*ty + _afMatrix[8]*tz + _afMatrix[12];
		_afMatrix[13] = _afMatrix[1]*tx + _afMatrix[5]*ty + _afMatrix[9]*tz + _afMatrix[13];
		_afMatrix[14] = _afMatrix[2]*tx + _afMatrix[6]*ty + _afMatrix[10]*tz + _afMatrix[14];
		_afMatrix[15] = _afMatrix[3]*tx + _afMatrix[7]*ty + _afMatrix[11]*tz + _afMatrix[15];
	}
	
	public function translation_set( tx :Float, ty :Float, tz :Float ){
		_afMatrix[12] = _afMatrix[0]*tx + _afMatrix[4]*ty + _afMatrix[8]*tz;
		_afMatrix[13] = _afMatrix[1]*tx + _afMatrix[5]*ty + _afMatrix[9]*tz;
		_afMatrix[14] = _afMatrix[2]*tx + _afMatrix[6]*ty + _afMatrix[10]*tz;
		//_afMatrix[15] = _afMatrix[3]*tx + _afMatrix[7]*ty + _afMatrix[11]*tz;
	}
	
//_____

	//SRC : http://code.google.com/p/glmatrix/source/browse/glMatrix.js
	public function rotate(
		fAngleRad :Float,
		fAxisX :Float,
		fAxisY :Float,
		fAxisZ :Float
	){
		var x = fAxisX;
		var y = fAxisY;
		var z = fAxisZ;
		var len = Math.sqrt( fAxisX*fAxisX + fAxisY*fAxisY + fAxisZ*fAxisZ );
		
		if( Math.isNaN( len ) ) return null;
		if( len != 1 ){
			len = 1 / len;
			x *= len; 
			y *= len; 
			z *= len; 
		}
		
		var s = Math.sin(fAngleRad);
		var c = Math.cos(fAngleRad);
		var t = 1-c;
		
		// Cache the matrix values (makes for huge speed increases!)
		var a00 = _afMatrix[0];
		var a01 = _afMatrix[1];
		var a02 = _afMatrix[2];
		var a03 = _afMatrix[3];
		var a10 = _afMatrix[4];
		var a11 = _afMatrix[5];
		var a12 = _afMatrix[6];
		var a13 = _afMatrix[7];
		var a20 = _afMatrix[8];
		var a21 = _afMatrix[9];
		var a22 = _afMatrix[10];
		var a23 = _afMatrix[11];
 
		// Construct the elements of the rotation matrix
		var b00 = x*x*t + c;
		var b01 = y*x*t + z*s;
		var b02 = z*x*t - y*s;
		var b10 = x*y*t - z*s;
		var b11 = y*y*t + c;
		var b12 = z*y*t + x*s;
		var b20 = x*z*t + y*s;
		var b21 = y*z*t - x*s;
		var b22 = z*z*t + c;
 
		// Perform rotation-specific matrix multiplication
		_afMatrix[0] = a00*b00 + a10*b01 + a20*b02;
		_afMatrix[1] = a01*b00 + a11*b01 + a21*b02;
		_afMatrix[2] = a02*b00 + a12*b01 + a22*b02;
		_afMatrix[3] = a03*b00 + a13*b01 + a23*b02;
		 
		_afMatrix[4] = a00*b10 + a10*b11 + a20*b12;
		_afMatrix[5] = a01*b10 + a11*b11 + a21*b12;
		_afMatrix[6] = a02*b10 + a12*b11 + a22*b12;
		_afMatrix[7] = a03*b10 + a13*b11 + a23*b12;
		 
		_afMatrix[8] = a00*b20 + a10*b21 + a20*b22;
		_afMatrix[9] = a01*b20 + a11*b21 + a21*b22;
		_afMatrix[10] = a02*b20 + a12*b21 + a22*b22;
		_afMatrix[11] = a03*b20 + a13*b21 + a23*b22;
		
		return;
		
	}
	
	//SRC : http://code.google.com/p/glmatrix/source/browse/glMatrix.js
	public function rotateX( fAngleRad :Float ){
		var s = Math.sin(fAngleRad);
		var c = Math.cos(fAngleRad);
		
		// Cache the matrix values (makes for huge speed increases!)
		var a10 = _afMatrix[4];
		var a11 = _afMatrix[5];
		var a12 = _afMatrix[6];
		var a13 = _afMatrix[7];
		var a20 = _afMatrix[8];
		var a21 = _afMatrix[9];
		var a22 = _afMatrix[10];
		var a23 = _afMatrix[11];

		// Perform axis-specific matrix multiplication
		_afMatrix[4] = a10*c + a20*s;
		_afMatrix[5] = a11*c + a21*s;
		_afMatrix[6] = a12*c + a22*s;
		_afMatrix[7] = a13*c + a23*s;
		 
		_afMatrix[8] = a10*-s + a20*c;
		_afMatrix[9] = a11*-s + a21*c;
		_afMatrix[10] = a12*-s + a22*c;
		_afMatrix[11] = a13*-s + a23*c;
	}
	
	public function rotateY( fAngleRad :Float ){
		var s = Math.sin(fAngleRad);
		var c = Math.cos(fAngleRad);
		
		// Cache the matrix values (makes for huge speed increases!)
		var a00 = _afMatrix[0];
		var a01 = _afMatrix[1];
		var a02 = _afMatrix[2];
		var a03 = _afMatrix[3];
		var a20 = _afMatrix[8];
		var a21 = _afMatrix[9];
		var a22 = _afMatrix[10];
		var a23 = _afMatrix[11];
		
		// Perform axis-specific matrix multiplication
		_afMatrix[0] = a00*c + a20*-s;
		_afMatrix[1] = a01*c + a21*-s;
		_afMatrix[2] = a02*c + a22*-s;
		_afMatrix[3] = a03*c + a23*-s;
		 
		_afMatrix[8] = a00*s + a20*c;
		_afMatrix[9] = a01*s + a21*c;
		_afMatrix[10] = a02*s + a22*c;
		_afMatrix[11] = a03*s + a23*c;
	}
	
	//SRC : http://code.google.com/p/glmatrix/source/browse/glMatrix.js
	public function rotateZ( fAngleRad :Float ){
		var s = Math.sin(fAngleRad);
		var c = Math.cos(fAngleRad);
 
		// Cache the matrix values (makes for huge speed increases!)
		var a00 = _afMatrix[0];
		var a01 = _afMatrix[1];
		var a02 = _afMatrix[2];
		var a03 = _afMatrix[3];
		var a10 = _afMatrix[4];
		var a11 = _afMatrix[5];
		var a12 = _afMatrix[6];
		var a13 = _afMatrix[7];

		// Perform axis-specific matrix multiplication
		_afMatrix[0] = a00*c + a10*s;
		_afMatrix[1] = a01*c + a11*s;
		_afMatrix[2] = a02*c + a12*s;
		_afMatrix[3] = a03*c + a13*s;
		 
		_afMatrix[4] = a00*-s + a10*c;
		_afMatrix[5] = a01*-s + a11*c;
		_afMatrix[6] = a02*-s + a12*c;
		_afMatrix[7] = a03*-s + a13*c;
	}
/*
	public function rotationZ_add( fAngleRad :Float ){
		var s = Math.sin(fAngleRad);
		var c = Math.cos(fAngleRad);
 
		// Cache the matrix values (makes for huge speed increases!)
		var a00 = _afMatrix[0];
		var a01 = _afMatrix[1];
		var a02 = _afMatrix[2];
		var a03 = _afMatrix[3];
		var a10 = _afMatrix[4];
		var a11 = _afMatrix[5];
		var a12 = _afMatrix[6];
		var a13 = _afMatrix[7];
		
		_afMatrix[0] = b00*a00 + b01*a10 + b02*a20 + b03*a30;
		_afMatrix[1] = b00*a01 + b01*a11 + b02*a21 + b03*a31;
		_afMatrix[2] = b00*a02 + b01*a12 + b02*a22 + b03*a32;
		_afMatrix[3] = b00*a03 + b01*a13 + b02*a23 + b03*a33;
		
		_afMatrix[4] = b10*a00 + b11*a10 + b12*a20 + b13*a30;
		_afMatrix[5] = b10*a01 + b11*a11 + b12*a21 + b13*a31;
		_afMatrix[6] = b10*a02 + b11*a12 + b12*a22 + b13*a32;
		_afMatrix[7] = b10*a03 + b11*a13 + b12*a23 + b13*a33;

		// Perform axis-specific matrix multiplication
		_afMatrix[0] = a00*c + a10*s;
		_afMatrix[1] = a01*c + a11*s;
		_afMatrix[2] = a02*c + a12*s;
		_afMatrix[3] = a03*c + a13*s;
		 
		_afMatrix[4] = a00*-s + a10*c;
		_afMatrix[5] = a01*-s + a11*c;
		_afMatrix[6] = a02*-s + a12*c;
		_afMatrix[7] = a03*-s + a13*c;
	}*/
	
	//SRC : http://code.google.com/p/glmatrix/source/browse/glMatrix.js
	public function scale( sx :Float, sy :Float, sz :Float ){
		_afMatrix[0] *= sx;
		_afMatrix[1] *= sx;
		_afMatrix[2] *= sx;
		_afMatrix[3] *= sx;
		
		_afMatrix[4] *= sy;
		_afMatrix[5] *= sy;
		_afMatrix[6] *= sy;
		_afMatrix[7] *= sy;
		
		_afMatrix[8] *= sz;
		_afMatrix[9] *= sz;
		_afMatrix[10] *= sz;
		_afMatrix[11] *= sz;
	}
	
//_____________________________________________________________________________
	
	public function translation_get(){
		return new Vector3( _afMatrix[12], _afMatrix[13], _afMatrix[14] );
	}
	
	

//_____________________________________________________________________________
//	Other

	public static function identity_get(){
		if( _oIdentity == null )
			_oIdentity = new Matrix4();
		return _oIdentity;
	}
	
	//SRC : http://code.google.com/p/glmatrix/source/browse/glMatrix.js
	public function inverse( bTargetMyself :Bool =false){
		var oMatrix :Matrix4;
		if( bTargetMyself )
			oMatrix = this;
		else
			oMatrix = this.clone();

		// Cache the matrix values (makes for huge speed increases!)
		var a00 = oMatrix._afMatrix[0];
		var a01 = oMatrix._afMatrix[1];
		var a02 = oMatrix._afMatrix[2];
		var a03 = oMatrix._afMatrix[3];
		var a10 = oMatrix._afMatrix[4];
		var a11 = oMatrix._afMatrix[5];
		var a12 = oMatrix._afMatrix[6];
		var a13 = oMatrix._afMatrix[7];
		var a20 = oMatrix._afMatrix[8];
		var a21 = oMatrix._afMatrix[9];
		var a22 = oMatrix._afMatrix[10];
		var a23 = oMatrix._afMatrix[11];
		var a30 = oMatrix._afMatrix[12];
		var a31 = oMatrix._afMatrix[13];
		var a32 = oMatrix._afMatrix[14];
		var a33 = oMatrix._afMatrix[15];
		
		var b00 = a00*a11 - a01*a10;
		var b01 = a00*a12 - a02*a10;
		var b02 = a00*a13 - a03*a10;
		var b03 = a01*a12 - a02*a11;
		var b04 = a01*a13 - a03*a11;
		var b05 = a02*a13 - a03*a12;
		var b06 = a20*a31 - a21*a30;
		var b07 = a20*a32 - a22*a30;
		var b08 = a20*a33 - a23*a30;
		var b09 = a21*a32 - a22*a31;
		var b10 = a21*a33 - a23*a31;
		var b11 = a22*a33 - a23*a32;

		// Calculate the determinant (inlined to avoid double-caching)
		var invDet = 1/(b00*b11 - b01*b10 + b02*b09 + b03*b08 - b04*b07 + b05*b06);
		
		//TODO : when target = false inject directly in a new()
		oMatrix._afMatrix[0] = (a11*b11 - a12*b10 + a13*b09)*invDet;
		oMatrix._afMatrix[1] = (-a01*b11 + a02*b10 - a03*b09)*invDet;
		oMatrix._afMatrix[2] = (a31*b05 - a32*b04 + a33*b03)*invDet;
		oMatrix._afMatrix[3] = (-a21*b05 + a22*b04 - a23*b03)*invDet;
		oMatrix._afMatrix[4] = (-a10*b11 + a12*b08 - a13*b07)*invDet;
		oMatrix._afMatrix[5] = (a00*b11 - a02*b08 + a03*b07)*invDet;
		oMatrix._afMatrix[6] = (-a30*b05 + a32*b02 - a33*b01)*invDet;
		oMatrix._afMatrix[7] = (a20*b05 - a22*b02 + a23*b01)*invDet;
		oMatrix._afMatrix[8] = (a10*b10 - a11*b08 + a13*b06)*invDet;
		oMatrix._afMatrix[9] = (-a00*b10 + a01*b08 - a03*b06)*invDet;
		oMatrix._afMatrix[10] = (a30*b04 - a31*b02 + a33*b00)*invDet;
		oMatrix._afMatrix[11] = (-a20*b04 + a21*b02 - a23*b00)*invDet;
		oMatrix._afMatrix[12] = (-a10*b09 + a11*b07 - a12*b06)*invDet;
		oMatrix._afMatrix[13] = (a00*b09 - a01*b07 + a02*b06)*invDet;
		oMatrix._afMatrix[14] = (-a30*b03 + a31*b01 - a32*b00)*invDet;
		oMatrix._afMatrix[15] = (a20*b03 - a21*b01 + a22*b00)*invDet;
		
		return oMatrix;
	}
	
	//SRC : http://code.google.com/p/glmatrix/source/browse/glMatrix.js
	public function multiplyVector3( v :Vector3 ){
		var x = v.x;
		var y = v.y;
		var z = v.z;
	
		v.x = _afMatrix[0]*x + _afMatrix[4]*y + _afMatrix[8]*z + _afMatrix[12];
		v.y = _afMatrix[1]*x + _afMatrix[5]*y + _afMatrix[9]*z + _afMatrix[13];
		v.z = _afMatrix[2]*x + _afMatrix[6]*y + _afMatrix[10]*z + _afMatrix[14];
		
	}
	
	//SRC : http://code.google.com/p/glmatrix/source/browse/glMatrix.js
	public function multiply( oMatrix :IMatrix ){
		
		// Cache the matrix values (makes for huge speed increases!)
		var a00 = _afMatrix[0];
		var a01 = _afMatrix[1];
		var a02 = _afMatrix[2];
		var a03 = _afMatrix[3];
		var a10 = _afMatrix[4];
		var a11 = _afMatrix[5];
		var a12 = _afMatrix[6];
		var a13 = _afMatrix[7];
		var a20 = _afMatrix[8];
		var a21 = _afMatrix[9];
		var a22 = _afMatrix[10];
		var a23 = _afMatrix[11];
		var a30 = _afMatrix[12];
		var a31 = _afMatrix[13];
		var a32 = _afMatrix[14];
		var a33 = _afMatrix[15];
		 
		var b00 = oMatrix.get(0);
		var b01 = oMatrix.get(1);
		var b02 = oMatrix.get(2);
		var b03 = oMatrix.get(3);
		var b10 = oMatrix.get(4);
		var b11 = oMatrix.get(5);
		var b12 = oMatrix.get(6);
		var b13 = oMatrix.get(7);
		var b20 = oMatrix.get(8);
		var b21 = oMatrix.get(9);
		var b22 = oMatrix.get(10);
		var b23 = oMatrix.get(11);
		var b30 = oMatrix.get(12);
		var b31 = oMatrix.get(13);
		var b32 = oMatrix.get(14);
		var b33 = oMatrix.get(15);
		
		_afMatrix[0] = b00*a00 + b01*a10 + b02*a20 + b03*a30;
		_afMatrix[1] = b00*a01 + b01*a11 + b02*a21 + b03*a31;
		_afMatrix[2] = b00*a02 + b01*a12 + b02*a22 + b03*a32;
		_afMatrix[3] = b00*a03 + b01*a13 + b02*a23 + b03*a33;
		
		_afMatrix[4] = b10*a00 + b11*a10 + b12*a20 + b13*a30;
		_afMatrix[5] = b10*a01 + b11*a11 + b12*a21 + b13*a31;
		_afMatrix[6] = b10*a02 + b11*a12 + b12*a22 + b13*a32;
		_afMatrix[7] = b10*a03 + b11*a13 + b12*a23 + b13*a33;
		
		_afMatrix[8] = b20*a00 + b21*a10 + b22*a20 + b23*a30;
		_afMatrix[9] = b20*a01 + b21*a11 + b22*a21 + b23*a31;
		_afMatrix[10] = b20*a02 + b21*a12 + b22*a22 + b23*a32;
		_afMatrix[11] = b20*a03 + b21*a13 + b22*a23 + b23*a33;
		
		_afMatrix[12] = b30*a00 + b31*a10 + b32*a20 + b33*a30;
		_afMatrix[13] = b30*a01 + b31*a11 + b32*a21 + b33*a31;
		_afMatrix[14] = b30*a02 + b31*a12 + b32*a22 + b33*a32;
		_afMatrix[15] = b30*a03 + b31*a13 + b32*a23 + b33*a33;

	}
}