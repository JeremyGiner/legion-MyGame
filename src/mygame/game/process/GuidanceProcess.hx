package mygame.game.process;
import legion.BehaviourProcess;
import mygame.game.ability.Guidance;
import mygame.game.MyGame;

/**
 * ...
 * @author GINER Jérémy
 */
class GuidanceProcess extends BehaviourProcess<MyGame,Guidance> {

	public function new( oGame :MyGame ) {
		super( oGame );
	}
	
	override public function process() {
		for ( oGuidance in _mOption )
			oGuidance.process();
	}
	
}