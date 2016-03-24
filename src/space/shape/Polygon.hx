package space.shape;

import space.Vector3;

class Polygon {
	private var _aoPoint :Array<Vector3>;
	
	function new(){
		_aoPoint = new Array<Vector3>();
	}

//_____________________________________________________________________________

	function point_add( oPoint :Vector3 ){
		_aoPoint.push(oPoint);
	}


//_____________________________________________________________________________


}