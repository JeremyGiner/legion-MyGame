package mygame.game.misc;
import haxe.ds.IntMap;
import mygame.game.ability.Position;
import space.Vector2i;

/**
 * ...
 * @author GINER Jérémy
 */
class PositionDistance {
	
	var _iLoop :Int;
	var _moDelta :IntMap<IntMap<Vector2i>>;
//_____________________________________________________________________________
//	Constructor

	public function new() {
		_iLoop = null;
		_moDelta = new IntMap<IntMap<Vector2i>>();
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function delta_get( oPosition1 :Position, oPosition2 :Position ) {
		
		var iId1 = oPosition1.unit_get().identity_get();
		var iId2 = oPosition2.unit_get().identity_get();
		
		// Calc only one direction
		//if ( iId1 > iId2 ) 
			//return distance_get( oPosition2, oPosition1 );	//swap direction
			
		// Clean up ( reset on new loop )
		if ( _iLoop != oPosition1.unit_get().mygame_get().loopId_get() )
			_moDelta = new IntMap<IntMap<Vector2i>>();
		
		// Update first dimension
		if ( 
			_moDelta.get( iId1 ) == null 
		) {
			_moDelta.set( iId1, new IntMap<Vector2i>() );
			_moDelta.set( iId2, new IntMap<Vector2i>() );
		}
		
		// Update second dimension
		if ( 
			_moDelta.get( iId1 ).get( iId2 ) == null 
		) {
			var oVector = oPosition2.clone();
			oVector.vector_add( oPosition1.clone().mult(-1) );
			_moDelta.get( iId1 ).set( iId2, oVector );
			
			oVector.mult( -1);
			_moDelta.get( iId2 ).set( iId1, oVector );
		}
		
		return _moDelta.get( iId1 ).get( iId2 );
	}
	
	
}