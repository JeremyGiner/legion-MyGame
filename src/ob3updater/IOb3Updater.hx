package ob3updater;
import js.three.Object3D;

/**
 * ...
 * @author GINER Jérémy
 */
interface IOb3Updater {

	/**
	 * @return associated object3d, cannot be null
	 */
	public function object3d_get() :Object3D;
	
	public function update() :Void;
}