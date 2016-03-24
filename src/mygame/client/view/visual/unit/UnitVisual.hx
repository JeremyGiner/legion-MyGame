package mygame.client.view.visual.unit;

import js.three.*;
import Math;
import mygame.client.view.ob3updater.Follow;
import mygame.client.view.visual.gui.WeaponGauge;
import mygame.client.view.visual.MapVisual;
import mygame.game.entity.Player;
import mygame.game.entity.Unit;
import mygame.client.view.GameView;
import mygame.game.ability.Mobility;
import mygame.game.ability.Position;
import mygame.game.ability.Weapon;
import mygame.client.view.visual.gui.HealthGauge;
import mygame.client.view.visual.gui.LoyaltyGauge;
import mygame.client.view.visual.ability.WeaponVisual;
import trigger.eventdispatcher.EventDispatcher;
import mygame.client.view.visual.gui.IUnitGauge;
import utils.three.Coordonate;

import mygame.game.ability.*;

import trigger.*;

class UnitVisual<CUnit:Unit> extends EntityVisual<CUnit> {

	var _oGameView :GameView;
	var _oUnit :CUnit;
	var _oScene :Group;
	var _oInfoAnchor :Object3D;
	var _oGaugeHolder :Object3D;
	var _oSelection :Mesh = null;
	var _oSelectionPreview :Mesh = null;
	var _oWeaponRange :Mesh;
	
	var _aGauge :Array<IUnitGauge>;
	
	var _fSelectionScale :Float;
	
	var _oClickBox :Box3;
	
	public var onUpdateEnd :EventDispatcher;
	
	
	// Cache
	
	var _oPosition :Position;

	
//______________________________________________________________________________
//	Constructor

	function new( 
		oGameView :GameView, 
		oUnit :CUnit, 
		fSelectionScale :Float = 0.2 
	) {
		_oGameView = oGameView;
		_oUnit = oUnit;
		_fSelectionScale = fSelectionScale;
		
		_oClickBox = null;
		_aGauge = new Array<IUnitGauge>();
		
		_oScene = new Group();
		//_oScene.scale.multiplyScalar(10000);
		//_oScene.position.setZ( 5000 );
		_oScene.position.setZ( MapVisual.LANDHEIGHT );
		
		_oWeaponRange = null;
		
		
		
		//____
		
		super( _oUnit );
		
		//_____
		
		_oSelection = new Mesh( 
			_oGameView.geometry_get('gui_selection_circle'), 
			_oGameView.material_get('wireframe_white')
		);
		_oSelection.scale.set( _fSelectionScale, _fSelectionScale, _fSelectionScale );
		//_oSelection.position.set(0,0,0.1);
		_oSelection.visible = false;
		_oSelection.castShadow = true;
		
		_oScene.add( _oSelection );
		
		//_____
		
		_oSelectionPreview = new Mesh( 
			_oGameView.geometry_get('gui_selection_circle'), 
			_oGameView.material_get('wireframe_grey')
		);
		_oSelectionPreview.scale.set( _fSelectionScale*1.1, _fSelectionScale*1.1, _fSelectionScale*1.1 );
		//_oSelectionPreview.position.set(0,0,0.1);
		_oSelectionPreview.visible = false;
		_oSelectionPreview.castShadow = true;
		
		_oScene.add( _oSelectionPreview );
		
		//_____
		
		
		//_____
		
		_oInfoAnchor = new Object3D();
		
		_oInfoAnchor.position.set(0,-_fSelectionScale,0);
		//_oInfoAnchor.lookAt( );
		_oInfoAnchor.scale.set(0.25, 0.05, 1);
		_oScene.add( _oInfoAnchor );
		
		_info_update();
		//TODO : make locked matrix, to fix scale etc...
		
		
		_oGameView.scene_get().add( this.object3d_get() );
		
		
		//____
		
		_oGaugeHolder = new Object3D();
		//_oGaugeHolder.scale.set(0.01, 0.01, 0.01);
		_oGameView.sceneOrtho_get().add( _oGaugeHolder );
		_oGameView.ob3UpdaterManager_get().add( new  Follow( _oGameView, _oGaugeHolder, _oInfoAnchor ) );
		onUpdateEnd = new EventDispatcher();
		
		//________________
		// Ability
		
		for( oAbility in _oUnit.abilityMap_get() ) {
			switch( Type.getClass( oAbility ) ) {
				case Health :
					_oGaugeHolder.add( new HealthGauge( this, cast oAbility, _oGaugeHolder.children.length ) );
				case Weapon :
					var oAbilityW = cast(oAbility,Weapon);
					new WeaponVisual( this, cast oAbility, null );
					_oGaugeHolder.add( new WeaponGauge( this, cast oAbility, _oGaugeHolder.children.length ) );
					
					_oWeaponRange = new Mesh( 
						_oGameView.geometry_get('gui_selection_circle'), 
						_oGameView.material_get('wireframe_red')
					);
					
					_oWeaponRange.scale.set( 
						oAbilityW.rangeMax_get(), 
						oAbilityW.rangeMax_get(), 
						oAbilityW.rangeMax_get() 
					);
					//_oWeaponRange.position.set(0,0,0.1);
					_oWeaponRange.visible = false;
					//_oWeaponRange.castShadow = true;
					
					_oScene.add( _oWeaponRange );
				case LoyaltyShift :
					_oGaugeHolder.add( new LoyaltyGauge( this, cast oAbility ) );
			}
		}
		
		// Trigger
		_oUnit.mygame_get().onLoopEnd.attach( this );
		
		
		// update cache
		_oPosition = _oUnit.ability_get(Position);
	}
	
//______________________________________________________________________________
//	Accessor


	public function selectionScale_get() {
		return _fSelectionScale;
	}

	public function unit_get() :Unit { return _oUnit; }
	
	public function gameView_get() { return _oGameView; }
	
	override public function object3d_get() :Object3D { return _oScene; }
	
	public function infoAnchor_get() { return _oInfoAnchor; }
	
	public function gaugeHolder_get() {
		return _oGaugeHolder;
	}
	
	public function clickBox_get() {
		// Case : dead and decaying
		if ( unit_get() == null )
			return null;
		
		// Update click box
		if ( _oClickBox == null && _oScene.children.length > 1 ) {
			_clickBox_update();
		}
		
		return _oClickBox;
	}
	
//______________________________________________________________________________
//	Updater

	override public function update() {
		
		_oClickBox = null;
	
		// Update mesh' position
		if( _oPosition != null ) {
			_position_update();
			
			// get map visual
			var oMapVisual :MapVisual = cast _oGameView.entityVisual_get_byEntity( _oPosition.map_get() );
			
			_oScene.position.setZ( oMapVisual.height_get( _oPosition.x, _oPosition.y ) );
			_oScene.updateMatrix();
		}
		// Update gauge holder
		//_gaugeHolder_update();
		
		// trigger event
		onUpdateEnd.dispatch( this );
	}


//______________________________________________________________________________
//	Modifier
	
	public function selection_set( bSelection :Bool ) {
		_oSelection.visible = bSelection;
	}
	
	public function selectionPreview_set( bSelection :Bool ) {
		_oSelectionPreview.visible = bSelection;
	}
	
	public function rangeVisualVisibility_set( b :Bool ) {
		if ( _oWeaponRange != null )
			_oWeaponRange.visible = b;
	}
	
//______________________________________________________________________________
//	Sub-routine

	function _clickBox_update() {
			
		//var oObj = _oScene;
		var oObj = _oScene.children[_oScene.children.length - 1];
		_oClickBox = new Box3();
		_oClickBox.setFromObject( oObj );
	}

	function _position_update() {
		_oScene.position.setX( _oPosition.x/10000 );
		_oScene.position.setY( _oPosition.y/10000 );
	}

//______________________________________________________________________________
//	Utils

		// TODO : replace this solution with MaterialFaces
		// Description : Make a mesh with player material 
		function _playerColoredMesh_createAdd( oParent :Mesh, bFlat :Bool = false ) {
			var oMesh :Mesh;
			var oMaterial = null;
			if ( bFlat )
				oMaterial = _oGameView.material_get_byPlayer( 'player_flat', unit_get().owner_get() );
			else 
				oMaterial = _oGameView.material_get_byPlayer( 'player', unit_get().owner_get() );
			
			oMesh = new Mesh( untyped oParent.geometry.clone(), oMaterial );
			
			oParent.add( oMesh );
			return oMesh;
		}
		
		function _info_update() {
			_oInfoAnchor.updateMatrix();
		}
		
	public static function get_byRaycasting( 
		x :Int, y :Int, 
		oGameView :GameView 
	) :UnitVisual<Dynamic> {
		
		// Transform mouse coordonate
		var oVector = Coordonate.canva_to_eye( 
			x, y,
			oGameView.renderer_get() 
		);
		
		// Get raycaster
		var oRaycaster = new Raycaster();
		oRaycaster.setFromCamera( oVector, oGameView.camera_get() );
		
		// Get first unit visual with a clickbbox that intersect with ray
		for ( oUnitVisual in oGameView.unitVisual_get_all() ) {
			var oGeometry = oUnitVisual.clickBox_get();
			
			if ( oGeometry == null )
				continue;
			
			var aIntersect = oRaycaster.ray.intersectBox( oGeometry );
			if ( aIntersect != null )
				return oUnitVisual;
		}
		return null;
	}
	
//______________________________________________________________________________
//	Trigger

	override public function trigger( oSource :IEventDispatcher ) :Void { 
		
		if ( oSource == _oUnit.mygame_get().onLoopEnd ) {
			update();
			_info_update();
		}
		
		if( oSource == _oEntity.onDispose ) {
			
			// Starting death effect
			_decay_start();
		}
	}
	
	function _decay_start() {
		dispose(); //TODO : do more
	}
	
	override public function dispose() {
		
		// Clean trigger
		_oUnit.mygame_get().onLoopEnd.remove( this );
		
		// Dispose of members
		_oSelection.parent.remove( _oSelection ); _oSelection = null;
		_oInfoAnchor.parent.remove( _oInfoAnchor ); _oInfoAnchor = null;
		_oGaugeHolder.parent.remove( _oGaugeHolder ); _oGaugeHolder = null;
		
		// Wipe all out
		super.dispose();
	}
	
}