package utils.three;

import js.three.*;

//TODO : make oPlane a parameter

class Coordonate {
	static var _oProjector :Projector;
	static var _oPlane :Plane;
	static var _bInit :Bool = false;

//______________________________________________________________________________

	static function init() {
		if( _bInit )
			return;
		_oPlane = new Plane( new Vector3( 0, 0, 1 ), -0.25 );
		_oProjector = new Projector();
		_bInit = true;
	}

	// Description :
	//	Convert  
	//		[(0;0) top-left & (width;heigth) bottom-right] 
	//	into 
	//		[(0;0) center, (1,1) top-right]
	static public function canva_to_eye( 
		x :Int, 
		y :Int,
		oRenderer :WebGLRenderer, 
		?oVector :Vector3 = null 
	) :Vector3 {
		
		init();
	
		if( oVector == null )
				oVector = new Vector3();
		//TODO : add offset
		oVector.set(
				( x / oRenderer.domElement.clientWidth ) * 2 - 1,
				1 - ( y / oRenderer.domElement.clientHeight ) * 2, 
				0.5 
			);
		return oVector;
	}

//______________________________________________________________________________


	static public function screen_to_worldGround( 
		x :Int, 
		y :Int,
		oRenderer :WebGLRenderer,
		oCamera :Camera,
		?oVector :Vector3 = null 
	) :Vector3 {
	
		var oPlane = new Mesh( new PlaneGeometry( 2000000, 2000000 ), new MeshLambertMaterial() );
		oPlane.position.set(0, 0, 2500);
		init();
			
		if( oVector == null )
			oVector = new Vector3();
			
		//trace(_oPlane.distanceToPoint( oCamera.position));
		
		
		//Get eye coordonate
		canva_to_eye( x, y, oRenderer, oVector );
		//trace('X:'+oVector.x+';Y:'+oVector.y+';Z:'+oVector.z);
		
		var oRaycaster = new Raycaster();
		oRaycaster.setFromCamera( untyped oVector.clone(), oCamera );
		return oRaycaster.ray.intersectPlane( _oPlane );
	}

}