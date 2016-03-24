package space;

import space.IMatrix;

interface INode extends IMatrix{
	
	public function parent_set( oParent :INode ):INode;
	public function parent_get():INode;
	
	public function child_add( oNode :INode ):INode;
	public function child_remove( oNode :INode ):INode;
	
	public function upToDate_setFalse():INode;
	public function update():INode;
	
	//TODO : move to matrix4
	public function reset():INode;
	public function rotation_reset():INode;
}