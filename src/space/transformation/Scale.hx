package space.transformation;

import space.ITransformation;


class Scale implements ITransformation{
	private var _sx :Float;
	private var _sy :Float;
	private var _sz :Float;
	
	public function new( sx :Float, sy :Float, sz :Float){
		_sx = sx;
		_sy = sy;
		_sz = sz;
	}

	public function transform( oMatrix :Matrix4){
		oMatrix.scale( _sx, _sy,_sz );
	}
}