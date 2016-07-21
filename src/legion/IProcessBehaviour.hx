package legion;
import legion.entity.Entity;
import trigger.EventDispatcher2;

/**
 * ...
 * @author GINER Jérémy
 */
interface IProcessBehaviour<COption> extends IProcess {

	public function add( oEntity :Entity, oOption :COption ) :Void;
	public function remove( oEntity :Entity ) :Void;
	
	public function hasEntity( oEntity :Entity ) :Bool;
	public function option_get( oEntity :Entity ) :COption;
}