package mygame.client.view.visual;
import haxe.ds.IntMap;
import haxe.ds.ObjectMap;
import js.three.Object3D;
import js.three.Sprite;
import mygame.client.view.GameView;
import mygame.game.ability.Position;
import mygame.game.misc.Hit;
import mygame.game.process.WeaponProcess;
import mygame.client.view.visual.entity.WorldMapVisual;
import ob3updater.Animation;
import trigger.IEventDispatcher;
import trigger.ITrigger;

/**
 * ...
 * @author GINER Jérémy
 */
class HitVisual implements ITrigger {

	var _oGameView :GameView;
	
	var _mSprite :IntMap<Sprite>;
	
	// Cache
	
	var _oOnHit :IEventDispatcher;
	
	public function new( oGameView :GameView ) {
		_mSprite = new IntMap<Sprite>();
		
		_oGameView = oGameView;
		
		_oOnHit = _oGameView.model_get().game_get().singleton_get(WeaponProcess).onHit;
		_oOnHit.attach( this );
	}
	
	public function trigger( oSource :IEventDispatcher ) {
		
		if( _oOnHit == oSource ) {
			var oHit :Hit = _oOnHit.event_get();
			
			var oTarget = _oGameView.model_get().game_get().entity_get( oHit.targetId_get() );
			
			// Get psosition
			var oPos = oTarget.ability_get(Position);
			if( oPos == null )
				return;
			
			// Create sprite
			var fScale = oHit.damage_get() / 100;
			var oSprite = new Sprite( _oGameView.material_get('explosion').clone() );
			oSprite.position.set( 
				oPos.x / 10000,
				oPos.y / 10000,
				WorldMapVisual.LANDHEIGHT
			);
			oSprite.scale.set(fScale, fScale, fScale);
			oSprite.renderOrder = 10;
			_oGameView.scene_get().add( oSprite );
			_mSprite.set( oSprite.id, oSprite );
			
			// Create animation
			var oAnimation = new Animation( oSprite, 2000, [
				{ fKey: 0.0, mField: [ 'material.opacity' => 1.0 ] },
				{ fKey: 1.0, mField: [ 'material.opacity' => 0.0 ] }
			] );
			oAnimation.onEnd.attach( this );
			_oGameView.ob3UpdaterManager_get().add( oAnimation );
			return;
		}
		
		// Assume its an animation end
		var oObject3d :Object3D = cast oSource.event_get().object3d_get();
		
		// Remove object
		oObject3d.parent.remove( oObject3d );
		_mSprite.remove( oObject3d.id );
		_oGameView.ob3UpdaterManager_get().remove( oObject3d );
	}
}