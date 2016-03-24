package mygame.client.view.visual.ability;

import js.three.*;
import mygame.game.ability.Platoon;
import mygame.game.ability.Position;
import trigger.*;

import mygame.client.view.GameView;
import mygame.game.ability.Guidance;

//TODO : extends UnitAbilityVisual
class GuidanceVisual implements IVisual implements ITrigger {
	var _oLine :Line = null;
	var _oGuidance :Guidance;
	var _oGameView :GameView;
	
	static var _oMaterial :Material = { 
		new LineBasicMaterial( { color: 0x0000FF } ); 
	};

//______________________________________________________________________________
//	Constructor

	public function new( oGameView :GameView, oGuidance :Guidance ){
		_oGameView = oGameView;
		_oGuidance = oGuidance;
		
		_oLine = new Line( new Geometry(), untyped _oMaterial );
				
		_oGameView.scene_get().add( this.object3d_get() );
		update();
		
		_oGameView.model_get().game_get().onLoopEnd.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor
	
	public function object3d_get() :Object3D { return _oLine; }
	
//______________________________________________________________________________
//	Updater
	
	public function update() {
		
		if ( _oGuidance.goal_get() == null )
			if ( _oLine == null )
				return;
			else
				_oLine.visible = false;
		
		// Building geometry from pathfinder
		var geometry = new Geometry();
		var destination = _oGuidance.goal_get();
		
		if( destination != null ) {
			var oPosition = _oGuidance.mobility_get().position_get();
			
			geometry.vertices.push( 
				new Vector3( 
					Position.metric_unit_to_map( destination.x ), 
					Position.metric_unit_to_map( destination.y ), 
					0.51 
				)
			);
			geometry.vertices.push( 
				new Vector3( 
					Position.metric_unit_to_map( oPosition.x ), 
					Position.metric_unit_to_map( oPosition.y ), 
					0.51 
				)
			);
		}
		
		// Update geometry
		var scene = _oLine.parent;
		scene.remove(_oLine);
		_oLine = new Line( geometry, untyped _oMaterial );
		scene.add(_oLine);
	}
	
	public function _update() {
		
	}
	
//______________________________________________________________________________
//	Trigger
	
	public function trigger( oSource :IEventDispatcher ) :Void { 
		if ( oSource == _oGameView.model_get().game_get().onLoopEnd ) {
			update();
		}
	}
}