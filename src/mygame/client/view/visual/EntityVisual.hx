package mygame.client.view.visual;

import js.three.Matrix4;
import js.three.Raycaster;
import js.three.Vector3;
import mygame.client.view.GameView;
import mygame.client.view.visual.IVisual;
import legion.entity.Entity;
import haxe.ds.IntMap;
import js.three.Object3D;
import js.three.Camera;
import trigger.*;
import utils.Disposer;
import mygame.client.view.visual.unit.UnitVisual;

class EntityVisual<CEntity:Entity> implements IVisual implements ITrigger {
	var _oEntity :CEntity;
	
	static var _moEntityVisual = {
		_moEntityVisual = new IntMap<EntityVisual<Dynamic>>();
	};
//______________________________________________________________________________
//	Constructor

	function new( oEntity :CEntity ) {
		_oEntity = oEntity;
		
		_moEntityVisual.set( _oEntity.identity_get(), this );
		
		_oEntity.onDispose.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor

	public function object3d_get() :Object3D {
		throw("EntityVisual.object3d_get is abstract, override me ");
		return null;
	}
	
	public function update() {
		throw("EntityVisual.update is abstract, override me ");
		return null;
	}
	
	static public function get_all() {
		return _moEntityVisual;
	}
//______________________________________________________________________________
//	
	
	public static function get_byEntity( oEntity :Entity ) :EntityVisual<Dynamic> {
		return _moEntityVisual.get( oEntity.identity_get() );
	}
	
	
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		if( oSource == _oEntity.onDispose ) {
			dispose();
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