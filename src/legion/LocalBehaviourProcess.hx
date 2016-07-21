package legion;

/**
 * ...
 * @author GINER Jérémy
 */
class LocalBehaviourProcess<CGame:Game,CBehviour:IBehaviour> extends BehaviourProcess<CGame,CBehviour>{

	public function new( oGame :CGame ) {
		super( oGame );
	}
	
	override public function process() {
		for ( oBehviour in _mOption )
			oBehviour.process();
	}
	
}