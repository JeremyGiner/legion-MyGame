package space;

/**
 * 
 * @author GINER Jérémy
 */
interface IAlignedAxisBox  {

	public function center_get() :Vector3;
	
	public function width_get() :Float;
	public function height_get() :Float;
	
	public function halfWidth_get() :Float;
	public function halfHeight_get() :Float;
	
	public function top_get() :Float;
	public function bottom_get() :Float;
	public function right_get() :Float;
	public function left_get() :Float;
}