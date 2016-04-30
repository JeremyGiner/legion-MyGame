package logicweaver.node;

/**
 * @author GINER Jérémy
 */

interface INode {
	public function activate():Void;
	
	public function out_get() :Float;
}