package mygame.client.view.visual.gui;

import js.three.Object3D;
import mygame.client.model.Model;
import mygame.client.view.GameView;
import trigger.IEventDispatcher;
import js.three.Material;
import mygame.game.entity.Player;
import js.three.MeshFaceMaterial;
import js.three.Mesh;
import js.three.PlaneGeometry;
import js.three.MeshBasicMaterial;
import trigger.ITrigger;

/**
 * ...
 * @author GINER Jérémy
 */
class VictoryGauge implements ITrigger {

	var _oScene :Object3D;
	var _oArrow :Object3D;
	var _oGauge :Object3D;
	
	var _oMaterial :MeshFaceMaterial;
	
	var _oModel :Model;
	var _oGameView :GameView;
	
	public function new( oGameView :GameView, oModel :Model ) {
		
		_oModel = oModel;
		_oGameView = oGameView;
		
		_oScene = new Object3D();
		_oScene.position.set(0, 0.8, 0);
		_oScene.scale.set( 1, 0.1, 1);
		_oGameView.sceneOrtho_get().add( _oScene );
		
		_oMaterial = new MeshFaceMaterial( 
				[
					material_get_byPlayer(
						_oModel.playerLocal_get()
					),
					_oGameView.material_get('player_gauge_2'),
					_oGameView.material_get('player_gauge_*')
				]
		);
		//_oMaterial = new MeshBasicMaterial( { color:0x00FF00, depthTest:false, depthWrite:false } );
		/*trace( _oGameView.geometry_get('gui_loyalty') );
		trace( _oGameView.geometry_get('gui_loyalty').boundingBox );
		trace( _oGameView.geometry_get('hud_gauge').boundingBox );*/
		_oGauge = new Mesh( 
			_oGameView.geometry_get('gui_loyalty'), 
			//_oGameView.geometry_get('hud_gauge'), 
			//_oMaterial
			new MeshBasicMaterial({color:0x00FFFF, wireframe: true})
		);
		_oGauge.renderOrder = 12;
		//_oGauge.renderDepth = 12;
		_oGauge.position.setZ( -10);
		_oGauge.scale.set( 0.8, 0.8, 0.8 );
		//_oGauge.scale.set( 10, 10, 10 );
		//_oGauge.rotation.setY( 20 );
		_oScene.add( _oGauge );
		
		_oArrow = new Mesh( 
			new PlaneGeometry( 0.1, 2 ),
			new MeshBasicMaterial({color:0x00FF00,depthTest:false,depthWrite:false})
		);
		_oArrow.renderOrder = 10;
		//_oArrow.renderDepth = 10;
		_oArrow.scale.setY( 1.2 );
		_oGauge.add( _oArrow );
		
		_update();
		_oGameView.onFrame.attach( this );
	}
	
	function _update() {
		var oVictoryCondition = _oModel.game_get().oVictoryCondition;
			
		if( 
			oVictoryCondition.challenger_get() == _oGameView.model_get().playerLocal_get() ||
			oVictoryCondition.challenger_get() == null
		) {
			_oArrow.position.setX( -oVictoryCondition.value_get() );	//cursor to the left
			//_oMaterial.materials[1] = material_get(1);	//TODO : get random ennemy
			
		} else {
			_oArrow.position.setX( oVictoryCondition.value_get() );	//cursor to the right
			//_oMaterial.materials[1] = material_get_byPlayer( oVictoryCondition.challenger_get() );	//TODO : get random ennemy
			//_oMaterial.materials[1] = material_get( 1 );	//TODO : get random ennemy
		}
	}
	
	public function trigger( oSource :IEventDispatcher ) {
		if ( oSource == _oGameView.onFrame ) {
			_update();
		}
	}
	
//_____________________________________________________________________________
//	Sub-routine
	
	public function material_get_byPlayer( oPlayer :Player ) :Material { 
		if( 
			oPlayer == null ||
			oPlayer.playerId_get() > 2
		) 
			return _oGameView.material_get( 'player_gauge_*' );
		
		return _oGameView.material_get( 'player_gauge_'+(oPlayer.playerId_get()+1) ); 
	}
	public function material_get( iPlayerId :Int ) :Material { 
		if( 
			iPlayerId == null ||
			iPlayerId < 0 || iPlayerId > 2
		) 
			return _oGameView.material_get( 'player_gauge_*' );
		
		return _oGameView.material_get( 'player_gauge_'+( iPlayerId+1 ) ); 
	}
	
}