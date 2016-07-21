package mygame.client.view;

import js.three.*;
import js.three.Texture;
import js.three.Three;
import js.Browser;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
import mygame.client.view.html.BlockRoster;
import mygame.client.view.visual.entity.EntityVisualFactory;
import mygame.client.view.visual.gui.VictoryGauge;
import ob3updater.Ob3UpdaterManager;
import ob3updater.Transistion;

import legion.Game;
import mygame.client.view.visual.*;
import mygame.client.view.visual.unit.*;
import mygame.client.view.visual.ability.*;
import mygame.client.view.visual.gui.UnitSelectionPreview;
import legion.entity.Entity;
import legion.entity.Player;
import mygame.game.MyGame;
import mygame.client.model.GUI;
import mygame.client.model.Model;
import mygame.game.entity.*;
import mygame.game.ability.*;
import mygame.game.ability.Guidance;
import mygame.game.ability.Health;
import mygame.game.entity.WorldMap;
import mygame.game.tile.Tile;

import mygame.game.tile.*;

import trigger.*;
import trigger.eventdispatcher.EventDispatcher;

//import space.Vector3;

import mygame.client.view.MenuUnitSelectionView;

class GameView implements ITrigger {

	var _oModel :Model;
	var _oGame :Game;
	var _oGUI :GUI;
	
	var _oGameMenu :GameMenu;

	//___ ThreeJS
	
	var _oScene :Scene;
	var _oCamera :PerspectiveCamera;
	
	var _oSceneOrtho :Scene;
	var _oCameraOrtho :OrthographicCamera;
	
	var _oRenderer :WebGLRenderer;
	
	var _mTexture :StringMap<Texture>;
	var _moGeometry :StringMap<Geometry>;
	var _mMaterial :StringMap<Material>;
	
	//var _moDisplay :IntMap<Class<Dynamic>>;
	var _moVisualEntity :IntMap<IVisual>;
	var _aUnitVisual :Array<UnitVisual<Dynamic>>;
	
	var _oOb3UpdaterManager :Ob3UpdaterManager;
	
	
	var _oEntityVisualFactory :EntityVisualFactory;
	
	
	//_____ UserInterface
	var _aPlayerColor :Array<Color>;
	
	//_____Temp
	
	var _oTextureLoader :TextureLoader;
	
	//____ My
	
	var _iLoadProgress :Int = 0;

	public var oArrowDirection :Mesh;
	
	public var onFrame :EventDispatcher2<GameView>;
	
	static public var WORLDMAP_MESHSIZE :Float = 10;	//TODO : remove
	
	
//______________________________________________________________________________
// Constructor

	public function new( oModel :Model ) {
	
		_oEntityVisualFactory = new EntityVisualFactory( this );
		
		//TODO : check !=null
		_oModel = oModel;
		_oGame = oModel.game_get();
		_oGUI = oModel.GUI_get();
		
		//TOOD : check game and gui != null
		
		onFrame = new EventDispatcher2<GameView>();
		
		_oOb3UpdaterManager = new Ob3UpdaterManager();
		
		_oTextureLoader = new TextureLoader();
		
		// Init array
		
		_moGeometry = new StringMap<Geometry>();
		_mMaterial = new StringMap<Material>();
		
		_aUnitVisual = new Array<UnitVisual<Dynamic>>();
		
		_aPlayerColor = new Array<Color>();
		
		var oCanvas = js.Browser.document.getElementById('MyCanvas');

		
	//_____________________________
	//	Initialize SCENE
		_oScene = new Scene();
		//_oScene.scale.set(0.0001, 0.0001, 0.0001);
		_oScene.updateMatrix();
		_oScene.fog = new Fog( 0x7058f8, 900, 1000 );
		
	//_____________________________
		_oSceneOrtho = new Scene();
		
	//_____________________________
	//	Setting Camera

		/*
		var w = 800;
		var h = 600;
		*/
		var w = Browser.window.innerWidth;
		var h = Browser.window.innerHeight;
		_oCamera = new PerspectiveCamera(70, w/h, 1, 1000);
		_oCamera.position.z = 50;
		_oCamera.position.y = -30;
		_oCamera.lookAt(new Vector3(0, 0, 0));
		
		_oOb3UpdaterManager.add( new Transistion(_oCamera, 100) );
	
	//_____________________________
		// Directionnal light
		var oLightTmp = new DirectionalLight(0xFEFDD2, 1);
		
		oLightTmp.position.set( -1, -1, 5);
		
		/*
		oLightTmp.castShadow = true;
		oLightTmp.shadow.mapSize.width = 1024;
		oLightTmp.shadow.mapSize.height = 1024;
		untyped oLightTmp.shadow.camera.near = 1;
		untyped oLightTmp.shadow.camera.far = 100;
		untyped oLightTmp.shadow.camera.bottom = -10;
		untyped oLightTmp.shadow.camera.top = 10;
		untyped oLightTmp.shadow.camera.left = -10;
		untyped oLightTmp.shadow.camera.right = 10;
		oLightTmp.shadow.darkness = 0.5;
		//untyped oLightTmp.shadow.camera.position.set(10,10,0);
		untyped oLightTmp.shadow.camera.lookAt(new Vector3(5,5,0));
		
		var oCamHelper = new CameraHelper( oLightTmp.shadow.camera );
		_oScene.add( oCamHelper );
		*/
		
		_oScene.add( oLightTmp );
		
		var oLightTmp = new DirectionalLight(0xefefff, 1.5);
		oLightTmp.position.set( -1, -1, -1).normalize();
		_oScene.add( oLightTmp );
			
	//_____________________________
		// Ambient light
		//_oScene.add( new AmbientLight( 0x303030 ) );
		_oScene.add( new AmbientLight( 0x06012D ) );
		//_oScene.add( new AmbientLight( 0x000000 ) );
        
	
		
	//_____________________________
	//	Setting Camera Ortho 
	// /!\ (must be similar to perspective camera in size)
	// cf: view-source:http://threejs.org/examples/webgl_sprites.html
	
		//_oCameraOrtho = new OrthographicCamera(- w/2, w/2, h/2, - h/2, 1, 1000 );
		_oCameraOrtho = new OrthographicCamera(- 1, 1, 1, -1, 1, 1000 );
		_oCameraOrtho.position.z = 10;
	
	//_____________________________
	//	Setting Renderer
		
		_oRenderer = new WebGLRenderer({canvas: untyped oCanvas, antialias:true});
		_oRenderer.shadowMapEnabled = true;
	        
		_oRenderer.setSize(w, h);
		_oRenderer.setClearColor(new Color(0x7058f8),1);
	
		_oRenderer.autoClear = false; // To allow render overlay on top of sprited sphere
		var render_update = null;
		
		render_update = function(f:Float):Bool {
			
			// Update animation
			_oOb3UpdaterManager.process();
			
			// Tigger event
			onFrame.dispatch( this );
			
			// ??? relaunch event trigger for next frame maybe?
			Browser.window.requestAnimationFrame( render_update );
			//js.three.Three.requestAnimationFrame(render_update);
			
			// Render
			_oRenderer.clear();
			_oRenderer.render( _oScene, _oCamera, null, null );
			
			// Render ortho
			_oRenderer.clearDepth();
			_oRenderer.render( _oSceneOrtho, _oCameraOrtho, null, null );
			
			return true;
		}
		
		render_update(0);
		
		Browser.window.addEventListener( 'resize', 
			function( e :Dynamic ) {
				var w = Browser.window.innerWidth;
				var h = Browser.window.innerHeight;
				_oCamera.aspect = w / h;
				_oCamera.updateProjectionMatrix();
				
				_oRenderer.setSize( w, h );
			}, 
			false
		);
		
	//_____________________________
	//	Res laod
	
		_textureFile_load_all();
		_geometryFile_load_all();
		_materialFile_load_all();
		
		
		//GUIVisual
		//new GUIVisual( this, _oGUI);
		
	//_____________________________
	// Sub-component
	
		_oGameMenu = new GameMenu( _oModel );
		new HitVisual( this );
		
	}	

//______________________________________________________________________________

	/**
	 * Initialise
	 */
	public function init(){
		
		// Check if loading is complete
		if( _iLoadProgress > 0 ){
			trace('[ERROR] GameView : update : not done loading yet');
			return;
		}
		
		_texture_init();
		_material_init();
		_geometry_init();
		
		
		// TODO : move that to entityvisual
		//Draw entities
		for( oEntity in _oGame.entity_get_all() ){
			entityVisual_add( oEntity );
		}
		_oGame.onEntityNew.attach( this );
		
		new UnitSelection( this, _oModel );
		new VictoryGauge( this, _oModel );
		
		new UnitSelectionPreview( this, _oModel );
		
		oArrowDirection = new Mesh( geometry_get('gui_arrow_direction'), material_get('wireframe') );
		oArrowDirection.visible = false;
		oArrowDirection.scale.set( 0.2, 0.5, 0.5);
		scene_get().add( oArrowDirection );
	}
	
	public function entityVisual_add( oEntity :Entity ) :Void {
		var o = _entityVisual_create( oEntity );
		if( o != null && o.object3d_get() != null )
			_oScene.add( o.object3d_get() );
	}
	
	function _entityVisual_create( oEntity :Entity ) :IVisual {
		
		
		var oVisual = _oEntityVisualFactory.create( oEntity );
		if ( oVisual != null )
			return oVisual;

		if( Std.is( oEntity, Unit ) ) {
			var oUnit :Unit = cast oEntity;
			var oVisual :UnitVisual<Dynamic> = null;
			
			if( Std.is( oEntity, City ) )
				oVisual = new CityVisual( this, cast oEntity );
					
			if( Std.is( oEntity, Factory ) )
				oVisual = new FactoryVisual( this, cast oEntity );
			
			if( Std.is( oEntity, Copter ) )
				oVisual = new CopterVisual( this, cast oEntity );
			
			if( Std.is( oEntity, Bazoo ) )
				//oVisual = new BazooVisual( this, cast oEntity );
				oVisual = new SoldierVisual( this, cast oEntity );
			
			if( Std.is( oEntity, Tank ) )
				oVisual = new TankVisual( this, cast oEntity );
			
			if( Std.is( oEntity, Soldier ) )
				oVisual = new SoldierVisual( this, cast oEntity );
			
			if( Std.is( oEntity, SubUnit ) )
				oVisual = new SoldierVisual( this, cast oEntity );
			
			_aUnitVisual.push( oVisual );
			
			//TEST
			if( Std.is( oEntity, Tank ) && oEntity.identity_get() == 11 )
				_oOb3UpdaterManager.add( new Transistion(oVisual.object3d_get(), 45) );
			
			return oVisual;
		}
		
		
		return null;
	}
	
	public function JSONgeometry_load( sURI :String, sKey :String){
		_iLoadProgress++;
	
		var loader = new js.three.JSONLoader();
		loader.load(
			sURI, 
			function( oGeometry, oMaterials, oDisplayer ) {
				
				oDisplayer.geometry_add( oGeometry, sKey );
				
				fileLoadEnd( oGeometry );
				
			}.bind(_,_,this)
		);
	}
	
	public function fileLoadEnd( oSubject :Dynamic ) {
		_iLoadProgress--;
		
		if ( _iLoadProgress == 0 )
			init();
	}
	
//______________________________________________________________________________
// Accessor

	public function model_get(){ return _oModel; }
	
	public function scene_get(){return _oScene;}
	public function camera_get(){return _oCamera;}
	
	public function sceneOrtho_get(){return _oSceneOrtho;}
	public function cameraOrtho_get(){return _oCameraOrtho;}
		
	public function renderer_get(){return _oRenderer;}
	
	public function texture_get( sIndex :String ):Texture { 
		if ( !_mTexture.exists( sIndex ) )
			throw('[WARNING]:trying to use unloaded texture:' + sIndex);
			
		return _mTexture.get( sIndex ); 
	}
	public function geometry_get( sIndex :String ):Geometry { 
		if ( !_moGeometry.exists( sIndex ) )
			throw('[WARNING]:trying to use unloaded geometry:'+sIndex);
		return _moGeometry.get( sIndex ); 
	}
	//public function material_get( sIndex :String ):Material{ return _mMaterial.get( sIndex ); }
	public function material_get( sIndex :String ):Material { 
		//untyped _mMaterial.get( sIndex ).wireframe = true;
		if ( _mMaterial.get( sIndex ) == null ) 
			return new MeshLambertMaterial({/*shading: Shading.FlatShading*/});	//TEST
		if ( _mMaterial.get( sIndex ) == null ) 
			throw('!');
		return _mMaterial.get( sIndex ); 
	}
	
	public function entityVisual_get_byEntity( oEntity :Entity ){
		//TODO
		return EntityVisual.get_byEntity( oEntity );
		//return _moVisualEntity.get( oEntity.identity_get() );
	}
	
	public function unitVisual_get_all() {
		return _aUnitVisual;
	}
	
	public function ob3UpdaterManager_get() {
		return _oOb3UpdaterManager;
	}
	
	public function gameMenu_get() {
		return _oGameMenu;
	}
	
//______________________________________________________________________________
//	Modifier

	public function geometry_add( oGeometry :Geometry, sKey :String ){
		_moGeometry.set( sKey, oGeometry );
	}
	
	public function material_add( oMaterial :Material, sKey :String ) {
		_mMaterial.set( sKey, oMaterial );
	}

//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		// on new entity
		if( oSource == _oGame.onEntityNew )
			entityVisual_add( oSource.event_get() );
	
	}
	
//______________________________________________________________________________
//	Sub-routine

	function _materialPlayer_gen(  sLabel :String, oMaterial :Material ) {
		var oMaterialTmp = null;
		
		// Player null
		oMaterialTmp = oMaterial.clone();
		untyped oMaterialTmp.color = _aPlayerColor[ 0 ];
		_mMaterial.set(
			sLabel+'_*', 
			oMaterialTmp
		);
		
		// Other player
		for( i in 1...3 ) {
			oMaterialTmp = oMaterial.clone();
			untyped oMaterialTmp.color = _aPlayerColor[ i ];
			_mMaterial.set(
				sLabel+'_'+i, 
				oMaterialTmp
			);
		}
	}

//______________________________________________________________________________
//	Shortcut
	
	
	public function material_get_byPlayer( sLabel :String, oPlayer :Player ) :Material { 
		if( 
			oPlayer == null ||
			oPlayer.playerId_get() > 2
		) 
			return material_get( sLabel+'_*' );
		
		return material_get( sLabel+'_'+(oPlayer.playerId_get()+1) ); 
	}

//______________________________________________________________________________
//	Texture loader
//	TODO: move into file or something

	function _textureFile_load_all() {
		
		_mTexture = new StringMap<Texture>();
		
		_textureFile_load( 'res/texture/tree.png', 'tree' );
		_textureFile_load( 'res/texture/worldmap.png', 'worldmap_atlas' );
		_textureFile_load( 'res/texture/soldier.png', 'soldier' );
		_textureFile_load( 'res/texture/helicopter.png', 'copter' );
		_textureFile_load( 'res/tank_bottom.png', 'tank_bottom' );
		_textureFile_load( 'res/building/city.png', 'city' );
		_textureFile_load( 'res/building/factory.png', 'factory' );
		_textureFile_load( 'res/texture/bubbleshield.png', 'bubbleshield' );
		_textureFile_load( 'res/texture/explosion_1.png', 'explosion' );
		
		//TODO: why not part of the tileset?
		_textureFile_load( 'res/texture/tile_grass.png', 'tile_grass' );
	}
	
	function _textureFile_load( sFileName :String, sKey :String ) {
		
		_iLoadProgress++;
		var oTexture = _oTextureLoader.load( sFileName, function( oTexture :Texture ) {			
			fileLoadEnd( oTexture );
		});
		
		oTexture.magFilter = TextureFilter.NearestFilter;
		oTexture.minFilter = TextureFilter.NearestFilter;
		oTexture.needsUpdate = true;
		
		_mTexture.set( sKey, oTexture );
		
	}
	
//_____________________________________
	
	function _texture_init() {
		_mTexture.set( 'tile_sea', _texture_get_fromAtlas( _mTexture.get('worldmap_atlas'), 256, 256, 0, 3 ) );
		_mTexture.set( 'tile_slope', _texture_get_fromAtlas( _mTexture.get('worldmap_atlas'), 256, 256, 2, 1 ) );
		
		// Road
		_mTexture.set( 'tile_road_cross', _texture_get_fromAtlas( _mTexture.get('worldmap_atlas'), 128, 128, 5, 4 ) );
		
		_mTexture.set( 'tile_road_WE', _texture_get_fromAtlas( _mTexture.get('worldmap_atlas'), 128, 128, 4, 4 ) );
		_mTexture.set( 'tile_road_NS', _texture_get_fromAtlas( _mTexture.get('worldmap_atlas'), 128, 128, 4, 5 ) );
		
		_mTexture.set( 'tile_road_NE', _texture_get_fromAtlas( _mTexture.get('worldmap_atlas'), 128, 128, 6, 6 ) );
		_mTexture.set( 'tile_road_SE', _texture_get_fromAtlas( _mTexture.get('worldmap_atlas'), 128, 128, 6, 7 ) );
		_mTexture.set( 'tile_road_SW', _texture_get_fromAtlas( _mTexture.get('worldmap_atlas'), 128, 128, 7, 7 ) );
		_mTexture.set( 'tile_road_NW', _texture_get_fromAtlas( _mTexture.get('worldmap_atlas'), 128, 128, 7, 6 ) );
	}
	/**
	 * 
	 * @param	oAtlas
	 * @param	iSizeX	cell size in pixel
	 * @param	iSizeY	cell size in pixel
	 * @param	iOffsetX	cell index on the grid (  ( 0, 0 ) is bottom left )
	 * @param	iOffsetY	cell index on the grid (  ( 0, 0 ) is bottom left )
	 */
	function _texture_get_fromAtlas( 
		oAtlas :Texture, 
		iSizeX :Int, iSizeY :Int, 
		iOffsetX :Int, iOffsetY :Int 
	) {
		var oTexture = oAtlas.clone(); // reload the file instead of clone() to solve bug where the clone have is black image
		oTexture.repeat.set( iSizeX / oAtlas.image.width, iSizeY / oAtlas.image.height );
		oTexture.offset.set( oTexture.repeat.x * iOffsetX, oTexture.repeat.x * iOffsetY );
		oTexture.needsUpdate = true;
		return oTexture;
	}
//______________________________________________________________________________
//	Geometry loader
//	TODO: move into file or something

	function _geometryFile_load_all() {
		JSONgeometry_load( "res/gui/loyalty_gauge.js", 'gui_loyalty');
		JSONgeometry_load( "res/gui/direction.js", 'gui_arrow_direction');
		
		JSONgeometry_load( "res/worldmap/tile_mountain.js", 'mountain');
		JSONgeometry_load( "res/worldmap/tile_forest.js", 'forest');
		/*JSONgeometry_load( "res/worldmap/tile.js", 'tile');*/
		
		JSONgeometry_load( 'res/worldmap/wall.js', 'wall');
		JSONgeometry_load( 'res/worldmap/wall_corner.js', 'wall_corner');
		
		JSONgeometry_load( "res/unit/tank_turret.js", 'tank_turret');
		JSONgeometry_load( "res/unit/tank_bottom.js", 'tank_body');
		JSONgeometry_load( "res/unit/helicopter.js", 'copter');
		JSONgeometry_load( "res/building/city.js", 'city');
		JSONgeometry_load( "res/building/factory.js", 'factory');
		JSONgeometry_load( "res/unit/soldier.js", 'soldier');
		JSONgeometry_load( "res/unit/bazooka.js", 'bazoo');
		JSONgeometry_load( 'res/gui/gauge.js', 'hud_gauge');
	}

	function _geometry_init() {
		
		//geometry_add( new PlaneGeometry( 2, 2 ), 'hud_gauge' );
		geometry_add( new PlaneGeometry( 1, 1 ), 'tile' );
		
		geometry_add( new PlaneGeometry( 2, 2, 2, 2 ), 'gui_guidancePreview' );
		
		geometry_add( cast new RingGeometry(1,1.1,6,1), 'gui_selection_circle' );
	}
	
//______________________________________________________________________________
	function _materialFile_load_all() {
		
	}
	function _material_init() {
		
	//_____________________________
	//	Loading Material
		var o = { color:0x000000, depthTest:false, depthWrite:false, shading: Shading.FlatShading };
		_mMaterial.set('hud_gauge_bg', new MeshBasicMaterial(o) );
		o.color = 0x11ff44;
		_mMaterial.set('hud_gauge', new MeshBasicMaterial(o) );
		o.color = 0xff4411;
		_mMaterial.set('hud_gauge_red', new MeshBasicMaterial(o) );
		
		_mMaterial.set('wireframe', new MeshBasicMaterial({color:0x00FFFF, wireframe: true, shading: Shading.NoShading}) );
		_mMaterial.set('wireframe_white', new MeshBasicMaterial({color:0xFFFFFF, wireframe: true, shading: Shading.NoShading}) );
		_mMaterial.set('wireframe_grey', new MeshBasicMaterial({color:0xFFAAAA, wireframe: true, shading: Shading.NoShading}) );
		_mMaterial.set('wireframe_red', new MeshBasicMaterial({color:0xFF0000, wireframe: true, shading: Shading.NoShading}) );
		
		// For montain
		_mMaterial.set('worldmap', new MeshBasicMaterial({map : texture_get('worldmap_atlas'), shading: Shading.FlatShading}) );
		
		var a = [
			'tile_slope',
			'tile_grass',
			'tile_sea',
			
			// Road
			'tile_road_cross', 
			
			'tile_road_WE',
			'tile_road_NS',
			
			'tile_road_NE',
			'tile_road_SE',
			'tile_road_SW',
			'tile_road_NW'
		];
		for( s in a )
			_mMaterial.set(s, new MeshLambertMaterial({map : texture_get(s) }) );
		
		_mMaterial.set(
			'tile_forest', 
			new MeshFaceMaterial( [
				material_get('tile_grass'),
				new MeshBasicMaterial( { map : texture_get('tree'), shading: Shading.FlatShading } )
			])
		);
	
		_mMaterial.set(
			'soldier', 
			new SpriteMaterial({map : texture_get('soldier'),color:0xFF0000})
		);
	//___
		_mMaterial.set(
			'copter', 
			new MeshLambertMaterial({map : texture_get('copter')})
		);
	//___
		_mMaterial.set(
			'tank', 
			new MeshLambertMaterial({map : texture_get('tank_bottom')})
		);
		
		_mMaterial.set(
			'city', 
			new MeshLambertMaterial({map : texture_get('city')})
		);
		
		_mMaterial.set(
			'factory', 
			new MeshLambertMaterial({map : texture_get('factory'), transparent:true, alphaTest:0.1})
		);
		
		_mMaterial.set('bubbleshield', new SpriteMaterial( { map: texture_get('bubbleshield'), color: 0xffffff, depthTest: false}) );
	//___
		
		_mMaterial.set(
			'wireframe', 
			new MeshBasicMaterial({ 
				wireframe: true, 
				color: 0xFFFFFF,
				wireframeLinewidth: 5,
				shading: Shading.NoShading
			}) 
		);
		_mMaterial.set(
			'gui_guidancePreview', 
			new MeshBasicMaterial(
				{ color: 0x00FFFF, wireframe: true, shading: Shading.NoShading }
			)
		);
		_mMaterial.set('gui_guidancePreviewLine', new LineBasicMaterial( { color: 0x00FFFF } ) );
		
	// Player material
	
		_aPlayerColor[0] = new Color( 'white' );	// Color of null
		_aPlayerColor[1] = new Color( 'blue' );	// Color of player.id == 0
		_aPlayerColor[2] = new Color( 'orange' );
		
		_materialPlayer_gen( 
			'soldier',
			new SpriteMaterial({map : texture_get('soldier'),color:0xFF0000})
		);
		_mMaterial.set(
			'ghost',
			new SpriteMaterial({map : texture_get('soldier'),depthTest: false})
		);
		
		_mMaterial.set(
			'explosion', 
			new SpriteMaterial({map : texture_get('explosion'),depthTest: false})
		);
		
		_materialPlayer_gen( 
			'player', 
			new MeshLambertMaterial( {  } ) 
		);
		_materialPlayer_gen( 
			'player_gauge', 
			new MeshBasicMaterial( { shading: Shading.NoShading } ) 
		);
		_materialPlayer_gen( 
			'player_flat', 
			new MeshLambertMaterial( { } ) 
		);
	}
}	// CLASS END
