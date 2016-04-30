package logicweaver_gigablaster.motor;

import logicweaver.entity.motor.IMotor;
import logicweaver.node.OutNode;
import haxe.ds.IntMap;
/**
 * 
 * @author GINER Jérémy
 */
class UnitOrder implements IMotor<IntMap<String>> {
	
//_____________________________________________________________________________
//	Constructor

	public function new() {
		
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function resolution_get() {
		return 2;
	}
	
	public function translate( aOutNode :Array<Float> ) :IntMap<String> {
		//aOutNode[0].value_get() // unit id
		//aOutNode[1].value_get() // order
		
		if( aOutNode[0] == null )
			return null;
		if( aOutNode[1] == null )
			return null;
			
		return [ Math.floor( aOutNode[0] ) => _order_translate( aOutNode[1] ) ];
	}
//_____________________________________________________________________________
//	Sub-routine
	
	function _order_translate( fOrder ) {
		var a = [
			// Moves
			0 => 'MN', 
			1 => 'MS', 
			2 => 'ME', 
			3 => 'MW', 
			// Advance moves
			4 => 'MNE', 
			5 => 'MNW', 
			6 => 'MSE', 
			7 => 'MSW', 
			// Ranged attack
			8 => 'AN', 
			9 => 'AS', 
			10 => 'AE', 
			11 => 'AW', 
		];
		return a[ Math.floor( fOrder ) ];
	}
}