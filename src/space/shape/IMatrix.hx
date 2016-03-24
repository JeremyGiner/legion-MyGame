package space;

interface IMatrix {
	

	//TODO : clone
	public function copy( oMatrix :IMatrix ):IMatrix;
	public function get( i :Int ):Float;
	public function set( i :Int, f :Float):IMatrix;
	
	public function translation_set( tx :Float, ty :Float, tz :Float ):Void;
	public function translation_add( tx :Float, ty :Float, tz :Float ):Void;
	public function scale( tx :Float, ty :Float, tz :Float ):Void;
	public function rotateX( fAngleRad :Float ):Void;
	public function rotateY( fAngleRad :Float ):Void;
	public function rotateZ( fAngleRad :Float ):Void;
	public function rotate(
		fAngleRad :Float,
		fAxisX :Float,
		fAxisY :Float,
		fAxisZ :Float
	):Void;
	
	public function multiply( matrix :IMatrix ):Void;
	
	public function inverse( bTargetMyself :Bool =false):Matrix4;
	
	public function translation_get():Vector3;
	
}