package space;

/**
 * 
 * @author GINER Jérémy
 */
interface IAlignedAxisBoxi  {

	//public function center_get() :Vector2i;
	
	public function width_get() :Int;
	public function height_get() :Int;
	
	public function top_get() :Int;
	public function bottom_get() :Int;
	public function right_get() :Int;
	public function left_get() :Int;
}