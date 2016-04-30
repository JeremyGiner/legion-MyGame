package mygame.game.process;

import legion.entity.Entity;
import mygame.game.ability.Mobility;
import mygame.game.MyGame;
import mygame.game.ability.Volume;
import mygame.game.query.EntityQuery;
import mygame.game.query.UnitDist;

import trigger.*;

class VolumeEjection implements ITrigger {

	var _oGame :MyGame;
	
	var _oQueryVolume :EntityQuery;
	var _oQueryMobility :EntityQuery;

//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame ) {
		_oGame = oGame;
		_oQueryVolume = new EntityQuery( _oGame, [ 'ability' => Volume ] );
		_oQueryMobility = new EntityQuery( _oGame, [ 'ability' => Mobility ] );
		
		_oGame.onLoop.attach( this );
		
	}
	
//______________________________________________________________________________
//	Accessor
	
	
//______________________________________________________________________________
//	Process
	
	function process() {
		
		// foreach Mobility
		for ( oUnit in _oQueryMobility.data_get(null) ) {
			
			var oMobility = oUnit.ability_get( Mobility );
			
			// Not necessary
			if ( oMobility == null )
				continue;
			
			// Reset volume ejection
			oMobility.force_set( 'volume', 0, 0, false );
			
			var oForce = oMobility.force_get( 'volume' );
			
			for ( oEntitySource in _oQueryVolume.data_get(null) ) {
				
				// Filter self
				if ( oEntitySource == oUnit )
					continue;
				
				// Get source volume
				var oVolume = oEntitySource.ability_get( Volume );
					
				// Get volume size of target
				var oVolumeTarget = oUnit.ability_get( Volume );
				var fVolumeTargetSize = ( oVolumeTarget != null ) ? 
					oVolumeTarget.size_get() : 
					0.0;
				
				// Get position delta between source and target
				var oVector = _oGame.positionDistance_get().delta_get( 
					oMobility.position_get(),
					oVolume.position_get()
				);
				
				// Case : no contact
				if ( oVector.length_get() > ( oVolume.size_get() + fVolumeTargetSize ) )
					continue;
				
				// Transform vector delta into ejection vector for this collision
				oVector.length_set( (( oVolume.size_get() + fVolumeTargetSize ) - oVector.length_get() ) / 2  );
				
				// Add to the ejection vector
				oForce.oVector.vector_add( oVector );
			}
			
		}
		
	} 
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		// on loop
		if( oSource == _oGame.onLoop )
			process();
	}
}