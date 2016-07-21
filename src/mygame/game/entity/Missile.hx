package mygame.game.entity;
import mygame.game.ability.Guidance;
import mygame.game.ability.GuidanceMissile;
import mygame.game.ability.Mobility;
import mygame.game.ability.Position;
import legion.entity.Entity;
import mygame.game.MyGame;
import space.Vector2i;

/**
 * ...
 * @author GINER Jérémy
 */
class Missile extends Projectile {

	public function new( oGame :MyGame, x :Int, y :Int, oTarget :Dynamic ) {
		super( oGame );
		
		_ability_add( new Position( this, oGame.map_get(), x, y ) );
		_ability_add( new Mobility( this, 1000 ) );
		if( Std.is(oTarget,Entity) )
			_ability_add( new GuidanceMissile( this, oTarget.identity_get() ) );
		else if( Std.is(oTarget,Vector2i) )
			_ability_add( new GuidanceProjectile( this, oTarget.identity_get() ) );
	}
	
}