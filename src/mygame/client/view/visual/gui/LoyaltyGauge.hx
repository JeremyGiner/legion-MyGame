package mygame.client.view.visual.gui;

import js.three.*;
import trigger.*;

import mygame.client.model.GUI;
import mygame.client.view.visual.EntityVisual;
import mygame.client.view.visual.unit.UnitVisual;
//import mygame.client.view.GameView;
import mygame.game.ability.LoyaltyShift in Loyalty;
import legion.entity.Player;

import trigger.*;

class LoyaltyGauge extends Mesh implements ITrigger {
	var _oUnitVisual :UnitVisual<Dynamic>;
	var _oLoyalty :Loyalty;
	
	var _oArrow :Mesh;
	
//______________________________________________________________________________
//	Constructor

	public function new( oUnitVisual :UnitVisual<Dynamic>, oLoyalty :Loyalty ) {
		_oLoyalty = oLoyalty;
		_oUnitVisual = oUnitVisual;
		
		super( 
			_oUnitVisual.gameView_get().geometry_get('gui_loyalty'), 
			new MeshFaceMaterial( 
				[
					material_get_byPlayer(
						_oUnitVisual.gameView_get().model_get().playerLocal_get()
					),
					_oUnitVisual.gameView_get().material_get('player_gauge_2'),
					_oUnitVisual.gameView_get().material_get('player_gauge_*')
				]
			)
		);
		
		this.renderOrder = 11;
		//this.renderDepth = 11;
		
		_oArrow = new Mesh( 
			new PlaneGeometry( 0.1, 2 ),
			new MeshBasicMaterial({color:0x000000,depthTest:false,depthWrite:false})
		);
		_oArrow.renderOrder = 12;
		//_oArrow.renderDepth = 12;
		_oArrow.scale.setY( 1.2 );
		this.add( _oArrow );
		
		_update();
		
		
		_oUnitVisual.gameView_get().onFrame.attach( this ); // TODO : improve
	}
	
//______________________________________________________________________________
//	Accessor

	function _update() {
		
		// If challenger == local player
		if( 
			_oLoyalty.challenger_get() == _oUnitVisual.gameView_get().model_get().playerLocal_get() ||
			_oLoyalty.challenger_get() == null
		) {
			_oArrow.position.setX( -_oLoyalty.loyalty_get() );	//cursor to the left
			untyped this.material.materials[1] = material_get(1);	//TODO : get random ennemy
			
		} else {
			_oArrow.position.setX( _oLoyalty.loyalty_get() );	//cursor to the right
			untyped this.material.materials[1] = material_get_byPlayer( _oLoyalty.challenger_get() );	//TODO : get random ennemy
		}
	}
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) {
		_update();
	}
	
//______________________________________________________________________________
//	
	public function material_get_byPlayer( oPlayer :Player ) :Material { 
		if( 
			oPlayer == null ||
			oPlayer.playerId_get() > 2
		) 
			return _oUnitVisual.gameView_get().material_get( 'player_gauge_*' );
		
		return _oUnitVisual.gameView_get().material_get( 'player_gauge_'+(oPlayer.playerId_get()+1) ); 
	}
	public function material_get( iPlayerId :Int ) :Material { 
		if( 
			iPlayerId == null ||
			iPlayerId < 0 || iPlayerId > 2
		) 
			return _oUnitVisual.gameView_get().material_get( 'player_gauge_*' );
		
		return _oUnitVisual.gameView_get().material_get( 'player_gauge_'+( iPlayerId+1 ) ); 
	}
}