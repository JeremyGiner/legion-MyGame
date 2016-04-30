package mygame.client.view.visual.gui;

import js.three.*;
import trigger.*;

import mygame.client.model.GUI;
import mygame.client.view.visual.EntityVisual;
import mygame.client.view.visual.unit.UnitVisual;
//import mygame.client.view.GameView;

class UnitGauge extends Mesh implements IUnitGauge implements ITrigger {
	
	var _iIndex :Int;
	var _oUnitVisual :UnitVisual<Dynamic>;
	
	var _oBackground :Mesh;
	var _oGauge :Mesh;
	
//______________________________________________________________________________
//	Constructor

	public function new( oUnitVisual :UnitVisual<Dynamic>, iIndex :Int, sMaterialKey :String = 'hud_gauge' ) {
		_oUnitVisual = oUnitVisual;
		_iIndex = iIndex;
		//_____
		// Init Background
		super( 
			_oUnitVisual.gameView_get().geometry_get('hud_gauge'), 
			_oUnitVisual.gameView_get().material_get('hud_gauge_bg')
		);
		this.renderOrder = 10;
		position.setY( _iIndex*2 );
		
		// Init Gauge
		
		_oGauge = new Mesh( 
			_oUnitVisual.gameView_get().geometry_get('hud_gauge'), 
			_oUnitVisual.gameView_get().material_get(sMaterialKey) 
		);
		_oGauge.renderOrder = 11;
		//_oGauge.renderDepth = 11;
		
		add( _oGauge );
		//_oUnitVisual.gameView_get().sceneOrtho_get().add( _oGauge );
		
		
		// Init trigger
		_oUnitVisual.onUpdateEnd.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor
//______________________________________________________________________________
//	Sub-routine
	
	/**
	 * Change size ( displayed value )
	 * @param	x	new size
	 */
	function _value_set( x :Float ) {
		
		// Case : value is 0 -> can't set scale at 0 
		if( x == 0 ) {
			_oGauge.visible = false;
			return;
		}
		
		// Cgange size
		_oGauge.scale.setX( x );
		_oGauge.visible = true;
	}
	

	function _update() {
		throw('Abstract');
		// Example 
		_oGauge.scale.setX( 0.5 );
	}
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) {
		//On Frame
		_update();
	}
	
}