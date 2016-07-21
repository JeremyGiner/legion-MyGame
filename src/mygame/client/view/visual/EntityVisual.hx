package mygame.client.view.visual;

import js.three.Matrix4;
import js.three.Raycaster;
import js.three.Vector3;
import mygame.client.view.GameView;
import mygame.client.view.visual.entity.WorldMapVisual;
import mygame.client.view.visual.IVisual;
import legion.entity.Entity;
import haxe.ds.IntMap;
import js.three.Object3D;
import js.three.Camera;
import mygame.game.ability.Position;
import trigger.*;
import utils.Disposer;
import mygame.client.view.visual.unit.UnitVisual;

class EntityVisual<CEntity:Entity> implements IVisual implements ITrigger {
	
	var _oGameView :GameView;
	var _oEntity :CEntity;
	var _oScene :Object3D;
	
	static var _moEntityVisual = {
		_moEntityVisual = new IntMap<EntityVisual<Dynamic>>();
	};
//______________________________________________________________________________
//	Constructor

	function new( oGameView, oEntity :CEntity ) {
		_oGameView = oGameView;
		_oEntity = oEntity;
		_oScene = new Object3D();
		
		_moEntityVisual.set( _oEntity.identity_get(), this );
		
		var oPosition :Position = cast _oEntity.abilityMap_get().get('mygame.game.ability.Position');
		if ( oPosition != null ) {
			_position_update( oPosition );
			oPosition.onUpdate.attach( this );
		}
		_oEntity.onDispose.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor

	public function object3d_get() :Object3D {
		return _oScene;
	}
	
	public function update() {
		
		// Position
		/*var oPosition :Position = cast _oEntity.abilityMap_get().get('mygame.game.ability.Position');
		if( oPosition != null )
			_position_update( oPosition );*/
	}
	
	static public function get_all() {
		return _moEntityVisual;
	}
	
//______________________________________________________________________________
//	Sub-routine

	function _position_update( oPosition :Position ) {
		
		_oScene.position.setX( Position.metric_unit_to_map( oPosition.x ) );
		_oScene.position.setY( Position.metric_unit_to_map( oPosition.y ) );
		
		_positionHeight_update( oPosition );
	}
	
	function _positionHeight_update( oPosition :Position ) {
		var oMapVisual :WorldMapVisual = cast _oGameView.entityVisual_get_byEntity( oPosition.map_get() );
		
		_oScene.position.setZ( oMapVisual.height_get( oPosition.x, oPosition.y ) );
		_oScene.updateMatrix();
	}
	
//______________________________________________________________________________
//	
	
	public static function get_byEntity( oEntity :Entity ) :EntityVisual<Dynamic> {
		return _moEntityVisual.get( oEntity.identity_get() );
	}
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		if ( Std.is( oSource.event_get(), Position ) ) {
			_position_update( cast oSource.event_get() );
			return;
		}
		
		if( oSource == _oEntity.onDispose ) {
			dispose();
			return;
		}
		
	}
	
//______________________________________________________________________________
//	Disposer
	
	public function dispose() {
		if ( object3d_get() != null )
			object3d_get().parent.remove( object3d_get() );
		_moEntityVisual.remove( _oEntity.identity_get() );
		Disposer.dispose( this );
	}
}