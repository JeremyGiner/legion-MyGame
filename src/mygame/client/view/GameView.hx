package mygame.client.view;


import js.three.*;
import js.three.Three;
import js.Browser;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
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

	//___ ThreeJS
	
	var _oScene :Scene;
	var _oCamera :PerspectiveCamera;
	
	var _oSceneOrtho :Scene;
	var _oCameraOrtho :OrthographicCamera;
	
	var _oRenderer :WebGLRenderer;
	
	var _moGeometry :StringMap<Geometry>;
	var _aoMaterial :StringMap<Material>;
	
	//var _moDisplay :IntMap<Class<Dynamic>>;
	var _moVisualEntity :IntMap<IVisual>;
	var _aUnitVisual :Array<UnitVisual<Dynamic>>;
	
	var _oOb3UpdaterManager :Ob3UpdaterManager;
	
	//_____ UserInterface
	var _aPlayerColor :Array<Color>;
	
	var _oMenuUnitSelection :MenuUnitSelectionView;
	var _oMenuCredit :MenuCredit;
	

	//_____Temp
	
	var _oTextureLoader :TextureLoader;
	
	//____ My
	
	var _iLoadProgress :Int = 0;
	
	public var onFrame :EventDispatcher;
	
	static public var WORLDMAP_MESHSIZE :Float = 10;	//TODO : remove
	
	
//______________________________________________________________________________
// Constructor

	public function new( oModel :Model ){
		//TODO : check !=null
		_oModel = oModel;
		_oGame = oModel.game_get();
		_oGUI = oModel.GUI_get();
		
		//TOOD : check game and gui != null
		
		onFrame = new EventDispatcher();
		
		_oOb3UpdaterManager = new Ob3UpdaterManager();
		
		_oTextureLoader = new TextureLoader();
		
		// Init array
		
		_moGeometry = new StringMap<Geometry>();
		_aoMaterial = new StringMap<Material>();
		
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
	
		_geometry_load();
		_material_load();
		
		
		//GUIVisual
		//new GUIVisual( this, _oGUI);
		
	// UserInterface
	/*
		_oMenuUnitSelection = new MenuUnitSelectionView( 
			_oGUI.unitSelection_get(), 
			cast js.Browser.document.getElementById('UnitSelection')
		);
		_oMenuCredit = new MenuCredit( 
			_oModel, 
			cast js.Browser.document.getElementById('Credit')
		);*/
		
		
		new GameMenu( _oModel );
		
	}	

//______________________________________________________________________________

	/**
	 * Initialise
	 */
	public function update(){
		
		// Check if loading is complete
		if( _iLoadProgress > 0 ){
			trace('[ERROR] GameView : update : not done loading yet');
			return;
		}
				
		// TODO : move that to entityvisual
		//Draw entities
		for( oEntity in _oGame.entity_get_all() ){
			entityVisual_add( oEntity );
		}
		_oGame.onEntityNew.attach( this );
		
		new UnitSelection( this, _oModel );
		new VictoryGauge( this, _oModel );
		
		new UnitSelectionPreview( this, _oModel );
	}
	
	public function entityVisual_add( oEntity :Entity ) :Void {
		var o = _entityVisual_create( oEntity );
		if( o != null && o.object3d_get() != null )
			_oScene.add( o.object3d_get() );
	}
	
	function _entityVisual_create( oEntity :Entity ) :IVisual {
		// TODO: move to EntityVisualResolver
		if( Std.is( oEntity, WorldMap ) )
			return new MapVisual( this, cast oEntity );
		

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
				oVisual = new BazooVisual( this, cast oEntity );
			
			if( Std.is( oEntity, Tank ) )
				oVisual = new TankVisual( this, cast oEntity );
			
			if( Std.is( oEntity, Soldier ) )
				oVisual = new SoldierVisual( this, cast oEntity );
			
			if( Std.is( oEntity, PlatoonUnit ) )
				oVisual = new PlatoonVisual( this, cast oEntity );
			
			if( Std.is( oEntity, SubUnit ) )
				oVisual = new SoldierVisual( this, cast oEntity );
			
			_aUnitVisual.push( oVisual );
				
		
			// TODO : move ability visual creation into unit visual initialisation
			// Ability
			var oGuidance :Guidance = oUnit.ability_get( Guidance );
			if( oGuidance != null )
				new GuidanceVisual( this, oUnit.ability_get( Guidance ) );
			
			
			//TEST
			if( Std.is( oEntity, Tank ) && oEntity.identity_get() == 11 )
				_oOb3UpdaterManager.add( new Transistion(oVisual.object3d_get(), 45) );
			
			return oVisual;
		}
		
		
		return null;
	}
	
	public function asset_load( sURI :String, sKey :String){
		_iLoadProgress++;
	
		var loader = new js.three.JSONLoader();
		loader.load(
			sURI, 
			function( oGeometry, oMaterials, oDisplayer ) {
				this._iLoadProgress--;
				oDisplayer.geometry_add( oGeometry, sKey );
				
				if( _iLoadProgress == 0 ) 
					init();
			}.bind(_,_,this)
		);
	}
	
	public function material_load( sURI :String, sPosition :String ){
		var oTextureTmp = new TextureLoader().load( sURI );
		oTextureTmp.magFilter = TextureFilter.NearestFilter;
		//oTextureTmp.minFilter = Three.LinearMipMapLinearFilter;
		//oTextureTmp.minFilter = TextureFilter.NearestFilter;
		
		_aoMaterial.set( sPosition, new MeshLambertMaterial({map : oTextureTmp}) );
	}
	
	function init(){
		update();
	}
	
//______________________________________________________________________________
// Accessor

	public function model_get(){ return _oModel; }
	
	public function scene_get(){return _oScene;}
	public function camera_get(){return _oCamera;}
	
	public function sceneOrtho_get(){return _oSceneOrtho;}
	public function cameraOrtho_get(){return _oCameraOrtho;}
		
	public function renderer_get(){return _oRenderer;}
	
	public function geometry_get( sIndex :String ):Geometry { 
		if ( !_moGeometry.exists( sIndex ) )
			throw('[WARNING]:trying to use unloaded ressource:'+sIndex);
		return _moGeometry.get( sIndex ); 
	}
	//public function material_get( sIndex :String ):Material{ return _aoMaterial.get( sIndex ); }
	public function material_get( sIndex :String ):Material { 
		//untyped _aoMaterial.get( sIndex ).wireframe = true;
		if ( _aoMaterial.get( sIndex ) == null ) 
			return new MeshLambertMaterial({/*shading: Shading.FlatShading*/});	//TEST
		if ( _aoMaterial.get( sIndex ) == null ) 
			throw('!');
		return _aoMaterial.get( sIndex ); 
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
	
//______________________________________________________________________________
//	Modifier

	public function geometry_add( oGeometry :Geometry, sKey :String ){
		_moGeometry.set( sKey, oGeometry );
	}
	
	public function material_add( oMaterial :Material, sKey :String ) {
		_aoMaterial.set( sKey, oMaterial );
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
		_aoMaterial.set(
			sLabel+'_*', 
			oMaterialTmp
		);
		
		// Other player
		for( i in 1...3 ) {
			oMaterialTmp = oMaterial.clone();
			untyped oMaterialTmp.color = _aPlayerColor[ i ];
			_aoMaterial.set(
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
//	TODO: move into file or something

	function _geometry_load() {
		//_____________________________
		//	Loading Geometry
		
		asset_load( "res/gui/loyalty_gauge.js", 'gui_loyalty');
		
		asset_load( "res/worldmap/tile_mountain.js", 'mountain');
		asset_load( "res/worldmap/tile_forest.js", 'forest');
		/*asset_load( "res/worldmap/tile.js", 'tile');*/
		geometry_add( new PlaneGeometry( 1, 1 ), 'tile' );
		asset_load( 'res/worldmap/wall.js', 'wall');
		asset_load( 'res/worldmap/wall_corner.js', 'wall_corner');
		
		asset_load( "res/unit/tank_turret.js", 'tank_turret');
		asset_load( "res/unit/tank_bottom.js", 'tank_body');
		asset_load( "res/unit/helicopter.js", 'copter');
		asset_load( "res/building/city.js", 'city');
		asset_load( "res/building/factory.js", 'factory');
		asset_load( "res/unit/soldier.js", 'soldier');
		asset_load( "res/unit/bazooka.js", 'bazoo');
		
		geometry_add( new PlaneGeometry( 2, 2 ), 'hud_gauge' );
		geometry_add( new PlaneGeometry( 2, 2, 2, 2 ), 'gui_guidancePreview' );
		
		geometry_add( cast new RingGeometry(1,1.1,32,3), 'gui_selection_circle' );
	}
	
//______________________________________________________________________________
	function _material_load() {
		
	//_____________________________
	//	Loading Material
		var o = { color:0x000000, depthTest:false, depthWrite:false, shading: Shading.FlatShading };
		_aoMaterial.set('hud_gauge_bg', new MeshBasicMaterial(o) );
		o.color = 0x11ff44;
		_aoMaterial.set('hud_gauge', new MeshBasicMaterial(o) );
		o.color = 0xff4411;
		_aoMaterial.set('hud_gauge_red', new MeshBasicMaterial(o) );
		
		
		
		
		
		_aoMaterial.set('wireframe', new MeshBasicMaterial({color:0x00FFFF, wireframe: true, shading: Shading.NoShading}) );
		_aoMaterial.set('wireframe_white', new MeshBasicMaterial({color:0xFFFFFF, wireframe: true, shading: Shading.NoShading}) );
		_aoMaterial.set('wireframe_grey', new MeshBasicMaterial({color:0xFFAAAA, wireframe: true, shading: Shading.NoShading}) );
		_aoMaterial.set('wireframe_red', new MeshBasicMaterial({color:0xFF0000, wireframe: true, shading: Shading.NoShading}) );
		
		material_load( 'res/building/factory.png', 'factory' );
		
	// Grass
		//TODO: why not part of the tileset?
		var oTextureTmp = _oTextureLoader.load( 'res/texture/tile_grass.png' );
		oTextureTmp.magFilter = TextureFilter.NearestFilter;
		oTextureTmp.minFilter = TextureFilter.NearestFilter;
		
		_aoMaterial.set('tile_grass', new MeshLambertMaterial( { map : oTextureTmp } ) );
		
		
		
	// Main worldmap
		trace( 'Loading wolad map' );
		oTextureTmp = _oTextureLoader.load( 'res/texture/worldmap.png' );
		oTextureTmp.magFilter = TextureFilter.NearestFilter;
		oTextureTmp.minFilter = TextureFilter.NearestFilter;
		
		_aoMaterial.set(
			'worldmap', 
			new MeshBasicMaterial({map : oTextureTmp, shading: Shading.FlatShading})
		);
		/*
		while( oTextureTmp.image == null ) {}
			trace( 'Loading' );*/
	// Sea
		oTextureTmp = _oTextureLoader.load( 'res/texture/worldmap.png' );
		oTextureTmp.magFilter = TextureFilter.NearestFilter;
		oTextureTmp.minFilter = TextureFilter.NearestFilter;
		
		oTextureTmp.repeat.set( 0.25, 0.25 );
		oTextureTmp.offset.set( 0, 0.75 );
		oTextureTmp.needsUpdate = true;
		
		_aoMaterial.set('tile_sea', new MeshLambertMaterial({map : oTextureTmp}) );
		
	// Slope
		oTextureTmp = _oTextureLoader.load( 'res/texture/worldmap.png' );
		oTextureTmp.magFilter = TextureFilter.NearestFilter;
		oTextureTmp.minFilter = TextureFilter.NearestFilter;
		oTextureTmp.repeat.set( 0.25, 0.25 );
		oTextureTmp.offset.set( 0.5, 0.25 );
		oTextureTmp.needsUpdate = true;
		
		_aoMaterial.set('tile_slope', new MeshLambertMaterial({map : oTextureTmp}) );
		
	// Road
		oTextureTmp = _oTextureLoader.load( 'res/texture/worldmap.png' );
		oTextureTmp.magFilter = TextureFilter.NearestFilter;
		oTextureTmp.minFilter = TextureFilter.NearestFilter;
		
		oTextureTmp.repeat.set( 0.125, 0.125 );
		oTextureTmp.offset.set( 0.625, 0.5 );
		oTextureTmp.needsUpdate = true;
		
		_aoMaterial.set('tile_road_cross', new MeshLambertMaterial({map : oTextureTmp}) ); // carrefour
		
		oTextureTmp = _oTextureLoader.load( 'res/texture/worldmap.png' );
		oTextureTmp.magFilter = TextureFilter.NearestFilter;
		oTextureTmp.minFilter = TextureFilter.NearestFilter;
		oTextureTmp.repeat.set( 0.125, 0.125 );
		oTextureTmp.offset.set( 0.5, 0.5 );
		oTextureTmp.needsUpdate = true;
		
		_aoMaterial.set('tile_road_WE', new MeshLambertMaterial({map : oTextureTmp}) ); // WE
		
		oTextureTmp = _oTextureLoader.load( 'res/texture/worldmap.png' );
		oTextureTmp.magFilter = TextureFilter.NearestFilter;
		oTextureTmp.minFilter = TextureFilter.NearestFilter;
		oTextureTmp.repeat.set( 0.125, 0.125 );
		oTextureTmp.offset.set( 0.5, 0.625 );
		oTextureTmp.needsUpdate = true;
		
		_aoMaterial.set('tile_road_NS', new MeshLambertMaterial({map : oTextureTmp}) ); // NS
		
		oTextureTmp = _oTextureLoader.load( 'res/texture/worldmap.png' );
		oTextureTmp.magFilter = TextureFilter.NearestFilter;
		oTextureTmp.minFilter = TextureFilter.NearestFilter;
		oTextureTmp.repeat.set( 0.125, 0.125 );
		oTextureTmp.offset.set( 0.75, 0.75 );
		oTextureTmp.needsUpdate = true;
		
		_aoMaterial.set('tile_road_NE', new MeshLambertMaterial({map : oTextureTmp}) ); // turn NE
		
		oTextureTmp = _oTextureLoader.load( 'res/texture/worldmap.png' );
		oTextureTmp.magFilter = TextureFilter.NearestFilter;
		oTextureTmp.minFilter = TextureFilter.NearestFilter;
		oTextureTmp.repeat.set( 0.125, 0.125 );
		oTextureTmp.offset.set( 0.75, 0.875 );
		oTextureTmp.needsUpdate = true;
		
		_aoMaterial.set('tile_road_SE', new MeshLambertMaterial({map : oTextureTmp}) ); // turn SE
		
		oTextureTmp = _oTextureLoader.load( 'res/texture/worldmap.png' );
		oTextureTmp.magFilter = TextureFilter.NearestFilter;
		oTextureTmp.minFilter = TextureFilter.NearestFilter;
		oTextureTmp.repeat.set( 0.125, 0.125 );
		oTextureTmp.offset.set( 0.875, 0.875 );
		oTextureTmp.needsUpdate = true;
		
		_aoMaterial.set('tile_road_SW', new MeshLambertMaterial({map : oTextureTmp}) ); // turn SW
		
		oTextureTmp = _oTextureLoader.load( 'res/texture/worldmap.png' );
		oTextureTmp.magFilter = TextureFilter.NearestFilter;
		oTextureTmp.minFilter = TextureFilter.NearestFilter;
		oTextureTmp.repeat.set( 0.125, 0.125 );
		oTextureTmp.offset.set( 0.875, 0.75 );
		oTextureTmp.needsUpdate = true;
		
		_aoMaterial.set('tile_road_NW', new MeshLambertMaterial({map : oTextureTmp}) ); // turn NW
		
		//_aoMaterial.set(1] = new ToonMaterial({map : oTextureTmp});
		//trace( _aoMaterial.set(0] );
		//trace( _aoMaterial.set(1] );
		//_oTestMaterial = new ToonMaterial({map : oTextureTmp});
	
	// Forest secondary texture
		oTextureTmp = _oTextureLoader.load( 'res/texture/tree.png' );
		oTextureTmp.magFilter = TextureFilter.NearestFilter;
		oTextureTmp.minFilter = TextureFilter.NearestFilter;
		
		_aoMaterial.set(
			'tile_forest', 
			new MeshFaceMaterial( [
				material_get('tile_grass'),
				new MeshBasicMaterial( { map : oTextureTmp, shading: Shading.FlatShading } )
			])
		);
	
	//___
		var oTextureTmp = _oTextureLoader.load( 'res/soldier.png' );
		oTextureTmp.magFilter = TextureFilter.NearestFilter;
		//oTextureTmp.minFilter = Three.LinearMipMapLinearFilter;
		oTextureTmp.minFilter = TextureFilter.NearestFilter;
		
		_aoMaterial.set(
			'soldier', 
			new MeshLambertMaterial({map : oTextureTmp})
		);
	//___
		var oTextureTmp = _oTextureLoader.load( 'res/texture/helicopter.png' );
		oTextureTmp.magFilter = TextureFilter.NearestFilter;
		//oTextureTmp.minFilter = Three.LinearMipMapLinearFilter;
		oTextureTmp.minFilter = TextureFilter.NearestFilter;
		
		_aoMaterial.set(
			'copter', 
			new MeshLambertMaterial({map : oTextureTmp})
		);
	//___
		var oTextureTmp = _oTextureLoader.load( 'res/tank_bottom.png' );
		oTextureTmp.magFilter = TextureFilter.NearestFilter;
		//oTextureTmp.minFilter = Three.LinearMipMapLinearFilter;
		oTextureTmp.minFilter = TextureFilter.NearestFilter;
		
		_aoMaterial.set(
			'tank', 
			new MeshLambertMaterial({map : oTextureTmp})
		);
		
		var oTextureTmp = _oTextureLoader.load( 'res/building/city.png' );
		oTextureTmp.magFilter = TextureFilter.NearestFilter;
		//oTextureTmp.minFilter = Three.LinearMipMapLinearFilter;
		oTextureTmp.minFilter = TextureFilter.NearestFilter;
		
		_aoMaterial.set(
			'city', 
			new MeshLambertMaterial({map : oTextureTmp})
		);
		
		var oTextureTmp = _oTextureLoader.load( 'res/building/factory.png' );
		oTextureTmp.magFilter = TextureFilter.NearestFilter;
		//oTextureTmp.minFilter = Three.LinearMipMapLinearFilter;
		oTextureTmp.minFilter = TextureFilter.NearestFilter;
		
		_aoMaterial.set(
			'factory', 
			new MeshLambertMaterial({map : oTextureTmp, transparent:true, alphaTest:0.1})
		);
	//___
		
		_aoMaterial.set(
			'wireframe', 
			new MeshBasicMaterial({ 
				wireframe: true, 
				color: 0xFFFFFF,
				wireframeLinewidth: 5,
				shading: Shading.NoShading
			}) 
		);
		_aoMaterial.set(
			'gui_guidancePreview', 
			new MeshBasicMaterial(
				{ color: 0x00FFFF, wireframe: true, shading: Shading.NoShading }
			)
		);
		_aoMaterial.set('gui_guidancePreviewLine', new LineBasicMaterial( { color: 0x00FFFF } ) );
		
	// Player material
	
		_aPlayerColor[0] = new Color( 'white' );	// Color of null
		_aPlayerColor[1] = new Color( 'blue' );	// Color of player.id == 0
		_aPlayerColor[2] = new Color( 'orange' );
		
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
