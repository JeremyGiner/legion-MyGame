package mygame.client.view.visual.ability;

import js.three.*;
import mygame.client.view.visual.unit.UnitVisual;
import mygame.game.ability.Platoon;
import mygame.game.ability.Position;
import mygame.game.entity.Unit;
import trigger.*;

import mygame.client.view.GameView;
import mygame.game.ability.Guidance;

//TODO : extends UnitAbilityVisual
class GuidanceVisual extends Object3D implements ITrigger {
	var _oLine :Line = null;
	var _oGuidance :Guidance;
	var _oUnitVisual :UnitVisual<Dynamic>;
	var _oUnit :Unit;
	
	static var _oMaterial :Material = { 
		new LineBasicMaterial( { color: 0x0000FF } ); 
	};

//______________________________________________________________________________
//	Constructor

	public function new( oUnitVisual :UnitVisual<Dynamic>, oGuidance :Guidance ) {
		super();
		_oUnitVisual = oUnitVisual;
		_oGuidance = oGuidance;
		
		_oLine = new Line( new Geometry(), untyped _oMaterial );
		
		add( this.object3d_get() );
		
		_update();
		
		_oUnit = _oUnitVisual.unit_get();
		_oUnit.mygame_get().onLoopEnd.attach( this );
		_oUnit.onDispose.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor
	
	public function object3d_get() :Object3D { return _oLine; }
	
//______________________________________________________________________________
//	Updater
	
	function _update() {
		
		if ( _oGuidance.goal_get() == null )
			if ( _oLine == null )
				return;
			else
				_oLine.visible = false;
		
		var destination = _oGuidance.goal_get();
		
		// Case no destination
		if ( destination == null )
			return;
		
		var oPosition = _oGuidance.mobility_get().position_get();
		
		var geometry = new Geometry();
		geometry.vertices = [ 
			new Vector3( 
				_oUnitVisual.object3d_get().position.x, 
				_oUnitVisual.object3d_get().position.y, 
				0.251 
			),
			new Vector3( 
				Position.metric_unit_to_map( destination.x ), 
				Position.metric_unit_to_map( destination.y ), 
				0.251 
			)
		];
		
		// Update geometry
		var scene = _oLine.parent;
		scene.remove(_oLine);
		_oLine = new Line( geometry, untyped _oMaterial );
		scene.add(_oLine);
	}
	
//______________________________________________________________________________
//	Trigger
	
	public function trigger( oSource :IEventDispatcher ) :Void { 
		if ( oSource == _oUnit.mygame_get().onLoopEnd ) {
			_update();
			return;
		}
		if ( oSource == _oUnit.onDispose ) {
			dispose();
			return;
		}
	}
//______________________________________________________________________________
//	disposer

	public function dispose() {
		_oLine.parent.remove( _oLine );
		
		_oUnit.mygame_get().onLoopEnd.remove( this );
		_oUnit.onDispose.remove( this );
	}
}