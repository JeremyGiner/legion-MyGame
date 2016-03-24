package space.transformation;

import space.ITransformation;
import space.Matrix4;


class Translate implements ITransformation {
	private var _tx :Float;
	private var _ty :Float;
	private var _tz :Float;
	
	public function new( tx :Float, ty :Float, tz :Float){
		_tx = tx;
		_ty = ty;
		_tz = tz;
	}
	
	public function transform( oMatrix :Matrix4){
		oMatrix.translation_add( _tx, _ty, _tz );
	}
	
	public function set( tx :Float, ty :Float, tz :Float){
		_tx = tx;
		_ty = ty;
		_tz = tz;
	}

}