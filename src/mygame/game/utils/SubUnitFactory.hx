package mygame.game.utils;
import legion.entity.Player;
import mygame.game.ability.Platoon;
import mygame.game.MyGame;
import space.Vector2i;

/**
 * ...
 * @author GINER Jérémy
 */
class SubUnitFactory {

	public function new() {
		
	}
	
	function _create( 
		sClassName :String, 
		oGame :MyGame, 
		oPlayer :Player, 
		oPosition :Vector2i, 
		oPlatoon :Platoon 
	) {
		return Type.createInstance( 
			Type.resolveClass(sClassName), 
			[
				oGame, 
				oPlayer, 
				oPosition, 
				oPlatoon 
			]
		);
	}
	
	static public function STcreate(
		sClassName :String, 
		oGame :MyGame, 
		oPlayer :Player, 
		oPosition :Vector2i, 
		oPlatoon :Platoon 
	) {
		var o = new SubUnitFactory();
		return o._create(
			sClassName, 
			oGame, 
			oPlayer, 
			oPosition, 
			oPlatoon
		);
	}
}