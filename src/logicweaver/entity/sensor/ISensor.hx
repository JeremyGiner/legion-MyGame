package logicweaver.entity.sensor;

/**
 * ...
 * @author GINER Jérémy
 */
interface ISensor {

	public function resolution_get() :Int;
	public function value_get() :Array<Float>;
	public function update_check() :Bool;
	
}