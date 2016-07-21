package legion;
import trigger.EventDispatcher2;

/**
 * ...
 * @author GINER Jérémy
 */
class Process {

	var onBefore :EventDispatcher2<Process>;
	var onAfter :EventDispatcher2<Process>;
	
	public function new() {
		onBefore = new EventDispatcher2<Process>();
		onAfter = new EventDispatcher2<Process>();
	}
	
	
	public function process() {
		throw('abstrac : override required');
	}
	
	public function name_get() {
		return Type.getClassName( Type.getClass( this ) );
	}
}