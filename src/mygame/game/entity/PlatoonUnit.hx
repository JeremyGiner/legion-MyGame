package mygame.game.entity;

import mygame.game.ability.GuidancePlatoon;
import mygame.game.MyGame in Game;
import mygame.game.ability.Volume;
import space.Vector2i;
import space.Vector3 in Vector2;
import mygame.game.ability.PositionPlan;
import mygame.game.ability.LoyaltyShifter;
import mygame.game.ability.Mobility;
import mygame.game.ability.Guidance;
import mygame.game.ability.Platoon in PlatoonAbility;
/**
 * ...
 * @author GINER Jérémy
 */
class PlatoonUnit extends Unit {

	var _aSubUnit :Array<SubUnit>;
	
	public function new( oGame :Game, oOwner :Player, oPosition :Vector2i ) {
		super( oGame, oOwner, oPosition );
		
		// Ability
		_ability_add( new Volume( this, 4000, 1 ) );
		_ability_add( new PositionPlan( this, 2 ) );
		_ability_add( new Mobility( this, 0.05 ) );
		
		
		var oAbility = new GuidancePlatoon( this );
		_ability_add( oAbility );
		_moAbility.set( Type.getClassName( Guidance ), oAbility );
		
		_ability_add( new PlatoonAbility( this ) );
	}
}