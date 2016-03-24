package utils.three;

import js.three.ShaderMaterial;
import js.three.Color;
import js.three.Vector3;
import js.three.Material;

import js.three.WebGLRenderer;

class ToonMaterial extends ShaderMaterial {


	public var color :Dynamic; // diffuse
	public var ambient :Dynamic;
	public var emissive :Dynamic;
	
	public var wrapAround = false;
	public var wrapRGB :Dynamic;
	
	public var map = null;
	
	public var lightMap = null;
	
	public var specularMap = null;
	
	public var envMap = null;
	public var combine :Dynamic;
	public var reflectivity = 1;
	public var refractionRatio = 0.98;
	
	public var wireframeLinecap = 'round';
	public var wireframeLinejoin = 'round';
	
	//____
	

//______________________________________________________________________________
// Constructor

	public function new( parameters ){
		super();
		
		color = new Color( 0xffffff ); // diffuse
		ambient = new Color( 0xffffff );
		emissive = new  Color( 0x000000 );
	
		wrapAround = false;
		wrapRGB = new Vector3( 1, 1, 1 );
		
		map = null;
		
		lightMap = null;
		
		specularMap = null;
		
		envMap = null;
		combine = js.three.Three.MultiplyOperation;
		reflectivity = 1;
		refractionRatio = 0.98;
		
		fog = true;
		
		shading = js.three.Three.SmoothShading;
		
		wireframe = false;
		wireframeLinewidth = 1;
		wireframeLinecap = 'round';
		wireframeLinejoin = 'round';
		
		vertexColors = untyped js.three.Three.NoColors;
		
		skinning = false;
		morphTargets = false;
		morphNormals = false;
		
		attributes =null;
		
	//____
	
		//uniforms = untyped THREE.UniformsUtils.clone( untyped THREE.ShaderLib.lambert.uniforms );
		uniforms = untyped THREE.UniformsUtils.merge( [
    untyped THREE.UniformsLib[ "common" ],
    untyped THREE.UniformsLib[ "fog" ],
    untyped THREE.UniformsLib[ "lights" ],
    untyped THREE.UniformsLib[ "shadowmap" ],
    {
        "ambient"  : { type: "c", value: new Color( 0xffffff ) },
        "emissive" : { type: "c", value: new Color( 0x000000 ) },
        "wrapRGB"  : { type: "v3", value: new Vector3( 1, 1, 1 ) },
        
        "map" : { type: "t", value: parameters.map },
    }
]);
		
		fragmentShader = untyped THREE.ShaderLib.lambert.fragmentShader;

		vertexShader = untyped THREE.ShaderLib.lambert.vertexShader;

		setValues( parameters );
	}
	
	override public function clone(?test : Material){
		js.Lib.alert('HO NO');
		return new Material();
	}

}