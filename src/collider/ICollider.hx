package collider;
import space.shape.IShape;
import space.Vector3;
import space.IAlignedAxisBox;

interface ICollider {
	
//_____________________________________________________________________________
//	Accessor
	
	public function position_get():Vector3;
	public function positionNext_get():Vector3;
	
	public function shape_get():IShape;
	
//_____________________________________________________________________________
	

}