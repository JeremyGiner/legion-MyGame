package mygame.client.view.visual.entity;

import js.three.*;
import mygame.client.view.visual.unit.UnitVisual;
import mygame.game.ability.Volume;
import mygame.game.entity.Projectile;
import mygame.client.view.GameView;

import mygame.game.ability.Weapon;
import mygame.game.ability.Mobility;

import Math;
/**
 * @author GINER Jérémy
 */
class ProjectileVisual extends EntityVisual<Projectile> {
	
	var _oSprite :Sprite;
	
//______________________________________________________________________________
//	Constructor

	public function new( oGameView :GameView, oMissile :Projectile ) {
		_oEntity = oMissile;
		super( oGameView, _oEntity );
		
		//_____
		
		
		
		
		//________________________
		// Setup body mesh
		_oSprite = new Sprite( _oGameView.material_get( 'bubbleshield' ) );
		_oScene.add( _oSprite );
		
		//Owner's color
		//_playerColoredMesh_createAdd( _oBody );
		
		update();

	}
	
//______________________________________________________________________________
//	Accessor
	
	override public function update() {
		super.update();
		
		
	}
	
	
	
	
	
}