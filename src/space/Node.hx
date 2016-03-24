package space;

//import space.IMatrix;
import space.Matrix4;
import space.ITransformation;

/*
import space.transformation.Translate;
import space.transformation.Scale;
import space.transformation.Rotate;
import space.transformation.RotateX;
import space.transformation.RotateY;
import space.transformation.RotateZ;*/
// TODO : put somewhere else
import js.html.CanvasRenderingContext2D;

class Node extends Matrix4 implements INode {
	
	private var _oParent :INode = null;
	private var _aoChild :Array<INode>;
	private var _aoTransformation :Array<ITransformation>;
	
	private var _oMatrixRelative :Matrix4;
	
	private var _bUpToDate :Bool = false;
	
//_____________________________________________________________________________

	public function new( 
		oParent :INode = null,
		a00 :Float = 1,
		a01 :Float = 0,
		a02 :Float = 0,
		a03 :Float = 0,
		
		a04 :Float = 0,
		a05 :Float = 1,
		a06 :Float = 0,
		a07 :Float = 0,
		
		a08 :Float = 0,
		a09 :Float = 0,
		a10 :Float = 1,
		a11 :Float = 0,
		
		a12 :Float = 0,
		a13 :Float = 0,
		a14 :Float = 0,
		a15 :Float = 1
	){
		super();
		
		_oMatrixRelative = new Matrix4(
			a00,a01,a02,a03,
			a04,a05,a06,a07,
			a08,a09,a10,a11,
			a12,a13,a14,a15
		);
		
		_aoChild = new Array<INode>();
		//_aoTransformation = new Array<ITransformation>();
		
		parent_set( oParent );
	}
	
//_____________________________________________________________________________
// Accessor

	override public function get( i :Int ){
		update();
		return super.get(i);
	}
	
	/*
	public function transformation_push( oITransformation :ITransformation ){
		_aoTransformation.push( oITransformation );
		upToDate_setFalse();
	}*/
	
	// TODO : remake this
	/*public function translate_set( index :Int, x :Float, y :Float, z :Float){
	
		if( index >= _aoTransformation.length)
			throw(index+' out of range');
		
		var t :Translate = cast _aoTransformation[index];
		
		t.set(x,y,z);
		
		upToDate_setFalse();
	}*/
	
	public function upToDate_setFalse(){
	
		// Check necessity
		if(!_bUpToDate) return this;
	
		// Set to false and child
		_bUpToDate = false;
		for( oNode in _aoChild){
			oNode.upToDate_setFalse();
		}
		
		return this;
	}
	
	public function reset(){
		_oMatrixRelative.copy( Matrix4.identity_get() );
		upToDate_setFalse();
		
		return this;
	}
	
	public function rotation_reset(){
		
		_oMatrixRelative.set( 0, 1 );
		_oMatrixRelative.set( 1, 0 );
		_oMatrixRelative.set( 2, 0 );
		_oMatrixRelative.set( 3, 0 );
		
		_oMatrixRelative.set( 4, 0 );
		_oMatrixRelative.set( 5, 1 );
		_oMatrixRelative.set( 6, 0 );
		_oMatrixRelative.set( 7, 0 );
		
		_oMatrixRelative.set( 8, 0 );
		_oMatrixRelative.set( 9, 0 );
		_oMatrixRelative.set( 10, 1 );
		_oMatrixRelative.set( 11, 0 );
		
		upToDate_setFalse();
		
		return this;
	}
	
	
	
//_____________________________________________________________________________
//	INode

	public function parent_get(){ return _oParent; }

	public function parent_set( oParent :INode ){
		
		// Check necessity
		if(_oParent == oParent) return this;
		
		// Unregister from previous parent
		if( oParent != null )
			oParent.child_remove(this);
		
		// Update parent
		_oParent = oParent;
		
		// Resgister as child if possible
		if( oParent != null )
			oParent.child_add(this);
		
		// Change status
		upToDate_setFalse();
		
		
		return this;
	}
	
	public function child_add( oChild :INode ){
		
		// Check new child validity
		if( 
			oChild == null || 
			oChild == this 
		) return this;
		
		// Check necessity
		for( oNode in _aoChild )
			if( oNode == oChild)
				return this;
		
		// Add child
		_aoChild.push( oChild );
		
		// Update child's parent
		oChild.parent_set( this );
		
		
		return this;
	}
	
	public function child_remove( oNode :INode ){
		
		// Check parameter validity
		if( oNode.parent_get() != this ) return this;
		
		// Remove child
		_aoChild.remove( oNode );
		
		// Update child's parent
		oNode.parent_set( null );
		
		
		return this;
	}

//_____________________________________________________________________________

	public function update(){

		// Check necessity
			if( _bUpToDate ) return this;
		
		// Copy parent
			if( _oParent != null )
				copy( _oParent );
			else
				copy( Matrix4.identity_get() );
				
		// Update absolute matrix
			multiply( _oMatrixRelative );
		
		// Apply each ITransformation
			//for( oTransformation in _aoTransformation ){
				//oTransformation.transform( this );
			//}
			
		// Update status
			_bUpToDate = true;
			
		return this;
	}
	
//_____________________________________________________________________________
//	Override matrix4 translate,scale,rotate


	override function translation_add( tx :Float, ty :Float, tz :Float ){
		_oMatrixRelative.translation_add(tx,ty,tz);
		upToDate_setFalse();
	}
	override function translation_set( tx :Float, ty :Float, tz :Float ){
		_oMatrixRelative.translation_set(tx,ty,tz);
		upToDate_setFalse();
	}
	
	override function scale( tx :Float, ty :Float, tz :Float ){
		_oMatrixRelative.scale(tx,ty,tz);
		upToDate_setFalse();
	}
	
	override function rotateX( fAngleRad :Float ){
		_oMatrixRelative.rotateX(fAngleRad);
		upToDate_setFalse();
	}
	
	override function rotateY( fAngleRad :Float ){
		_oMatrixRelative.rotateY(fAngleRad);
		upToDate_setFalse();
	}
	
	override function rotateZ( fAngleRad :Float ){
		_oMatrixRelative.rotateZ(fAngleRad);
		upToDate_setFalse();
	}
	/*
	TODO :
	public function rotate(
		fAngleRad :Float,
		fAxisX :Float,
		fAxisY :Float,
		fAxisZ :Float
	):Void*/
	
	override function inverse( ?b:Bool){
		update();
		return super.inverse(b);
	}
	
}