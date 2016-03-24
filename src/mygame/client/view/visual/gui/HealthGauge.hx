package mygame.client.view.visual.gui;

import js.three.*;
import trigger.*;

import mygame.client.model.GUI;
import mygame.client.view.visual.EntityVisual;
import mygame.client.view.visual.unit.UnitVisual;
//import mygame.client.view.GameView;
import mygame.game.ability.Health;

import trigger.*;

class HealthGauge extends UnitGauge {
	
	var _oHealth :Health;
	
	//_____
	
	static var _oMaterialBackground :MeshBasicMaterial = { 
		new MeshBasicMaterial({color:0x000000,depthTest:false,depthWrite:false});
	};
	static var _oMaterialGauge :MeshBasicMaterial = { 
		new MeshBasicMaterial({color:0x11ff44,depthTest:false,depthWrite:false});
	};
	
	static var _oGeometryBackground :Geometry = {
		new PlaneGeometry( 2, 2 );
	};
	static var _oGeometryGauge :Geometry = {
		new PlaneGeometry( 2, 2 );
		//new PlaneGeometry( 0.5, 0.5 );
	};
	
//______________________________________________________________________________
//	Constructor

	public function new( oUnitVisual :UnitVisual<Dynamic>, oHealth :Health, iIndex :Int ) {
		_oHealth = oHealth;
		super( oUnitVisual, iIndex );
		
		//_____
		/*
		_iAnchor = _oUnitVisual.anchor_get();
		
		// Setup Background
		
		_oBackground = new Mesh( _oGeometryBackground, _oMaterialBackground );
		_oBackground.renderDepth = 10;
		_oScene.add( _oBackground );
		
		// Setup Gauge
		
		_oGauge = new Mesh( _oGeometryGauge, _oMaterialGauge );
		_oGauge.renderDepth = 11;
		//_oGauge.scale.set( 0.8, 0.8, 0.8 );
		_oBackground.add( _oGauge );
		*/
		_update();
		
		//Trigger
		//oUnitVisual.gameView_get().onFrame.attach( this ); // TODO : improve
		_oHealth.onUpdate.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor

	override function _update() {
		
		// Change size depending on health
		var x = _oHealth.percent_get();
		if( x != 0 ) {
			_oGauge.scale.setX( x );
			_oGauge.visible = true;
		} else
			_oGauge.visible = false;
	}
}