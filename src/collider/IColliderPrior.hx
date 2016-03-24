package collider;
import space.shape.IShape;
import space.Vector3;
import space.IAlignedAxisBox;

interface IColliderPrior extends ICollider{
	
//_____________________________________________________________________________
//	Accessor

	public function velocity_get():Vector3;
	public function velocity_set( value:Vector3 );
	
//_____________________________________________________________________________

}