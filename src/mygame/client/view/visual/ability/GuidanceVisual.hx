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
		
		
		_oUnit =  cast _oUnitVisual.unit_get();
		
		_update();
		
		_oUnit.mygame_get().onLoopEnd.attach( this );
		_oUnit.onDispose.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor
	
	public function object3d_get() :Object3D { return _oLine; }
	
//______________________________________________________________________________
//	Updater
	
	function _update() {
		
		// Case : platoon
		var oPlatoon = _oUnit.ability_get(Platoon);
		if ( oPlatoon != null ) {
			_update_platoon( oPlatoon );
			return;
		}
		
		//__________________________
		
		var lWaypoint = _oGuidance.waypointList_get();
		if ( lWaypoint.length == 0 )
			if ( _oLine == null )
				return;
			else
				_oLine.visible = false;
		
		var destination = _oGuidance.waypointList_get().first();
		
		// Case no destination
		if ( lWaypoint.length == 0 )
			return;
		
		var oPosition = _oGuidance.mobility_get().position_get();
		
		var geometry = new Geometry();
		var aVector = [
			new Vector3( 
				_oUnitVisual.object3d_get().position.x, 
				_oUnitVisual.object3d_get().position.y, 
				0.251 
			)
		];
		for( oWaypoint in lWaypoint ) {
			aVector.push( 
				new Vector3( 
					Position.metric_unit_to_map( oWaypoint.x ), 
					Position.metric_unit_to_map( oWaypoint.y ), 
					0.251 
				)
			);
		}
		geometry.vertices = aVector;
		
		// Update geometry
		var scene = _oLine.parent;
		scene.remove(_oLine);
		_oLine = new Line( geometry, untyped _oMaterial );
		scene.add(_oLine);
	}
	
	function _update_platoon( oPlatoon :Platoon ) {
		
		// Make sure line is drawed once (only the commander's is drawed )
		if ( _oUnit != oPlatoon.commander_get() )
			return;
		
		
		var lWaypoint = _oGuidance.waypointList_get();
		if ( lWaypoint.length == 0 )
			if ( _oLine == null )
				return;
			else
				_oLine.visible = false;
		
		var destination = _oGuidance.waypointList_get().first();
		
		// Case no destination
		if ( lWaypoint.length == 0 )
			return;
		
		var oPosition = _oGuidance.mobility_get().position_get();
		
		
		var aVector = [
			_subUnitPositionAvr_get(oPlatoon)
		];
		for( oWaypoint in lWaypoint ) {
			aVector.push( 
				new Vector3( 
					Position.metric_unit_to_map( oWaypoint.x ), 
					Position.metric_unit_to_map( oWaypoint.y ), 
					0.251 
				)
			);
		}
		//__________
		var a = oPlatoon.subUnit_get();
		var oUnitLast = a[ a.length-1 ];
		
		var oGuidanceLast = oUnitLast.ability_get(Guidance);
		
		for( oWaypoint in oGuidanceLast.waypointList_get() ) {
			aVector.push( 
				new Vector3( 
					Position.metric_unit_to_map( oWaypoint.x ), 
					Position.metric_unit_to_map( oWaypoint.y ), 
					0.251 
				)
			);
		}
		
		// Update geometry
		var geometry = new Geometry();
		geometry.vertices = aVector;
		var scene = _oLine.parent;
		scene.remove(_oLine);
		_oLine = new Line( geometry, untyped _oMaterial );
		scene.add(_oLine);
	}
//______________________________________________________________________________
//	Sub-routine
	
	/**
	 * @return average of SubUnits position
	 */
	function _subUnitPositionAvr_get( oPlatoon :Platoon ) {
		var oPos = new Vector3();
		var aUnit = oPlatoon.subUnit_get();
		for ( oUnit in aUnit ) {
			oPos.x += oUnit.ability_get(Position).x;
			oPos.y += oUnit.ability_get(Position).y;
		}
		oPos.divideScalar( aUnit.length );
		
		oPos.x = Position.metric_unit_to_map( Std.int( oPos.x ) );
		oPos.y = Position.metric_unit_to_map( Std.int( oPos.y ) );
		oPos.z = 0.251;
		
		return oPos;
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