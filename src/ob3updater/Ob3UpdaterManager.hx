package ob3updater;
import haxe.ds.IntMap;
import js.three.Object3D;

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
	
	public function remove( oObj :Object3D ) {
		_aOb3Updater.remove( oObj.id );
	}
	
	public function process() {
		for ( oOb3Updater in _aOb3Updater ) {
			oOb3Updater.update();
		}
	}
}