package ob3updater;
import haxe.ds.IntMap;

/**
 * ...
 * @author GINER Jérémy
 */
class Ob3UpdaterManager {
	
	var _aOb3Updater :IntMap<IOb3Updater>;
	
	public function new() {
		_aOb3Updater = new IntMap<IOb3Updater> ();
	}
	
	public function add( oOb3Updater :IOb3Updater ) {
		_aOb3Updater.set( oOb3Updater.object3d_get().id, oOb3Updater );
	}
	
	public function process() {
		for ( oOb3Updater in _aOb3Updater ) {
			oOb3Updater.update();
		}
	}
}