package mygame.spirit.sensor;

/**
 * ...
 * @author GINER Jérémy
 */
interface ISensor {

	public function resolution_get() :Int;
	public function value_get() :Array<Float>;
	
}