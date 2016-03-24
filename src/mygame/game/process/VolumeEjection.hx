package mygame.game.process;

import legion.entity.Entity;
import mygame.game.ability.Mobility;
import mygame.game.MyGame;
import mygame.game.ability.Volume;

import trigger.*;

class VolumeEjection implements ITrigger {

	var _oGame :MyGame;
	
	var _loVolume :List<Volume>;

//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame ) {
		_oGame = oGame;
		
		_oGame.onLoop.attach( this );	//TODO : put before or after mobility process
		_oGame.onEntityNew.attach( this );
		_oGame.onAbilityDispose.attach( this );
		
		_loVolume = new List<Volume>();
		
	}
	
//______________________________________________________________________________
//	Accessor
	
	
//______________________________________________________________________________
//	Process
	
	function process() {
		
		// foreach Mobility
		for ( oUnit in _oGame.unitList_get() ) {
			
			var oMobility :Mobility = oUnit.ability_get( Mobility );
			
			if ( oMobility == null )
				continue;
				
			oMobility.force_set( 'volume', 0, 0, false );
			
			for ( oVolume in _loVolume ) {
				
				if ( oVolume.unit_get() == oUnit )
					continue;
				
				var fVolumeSecondSize = 0.0;
				var oVolumeSecond = oUnit.ability_get( Volume );
				if ( oVolumeSecond != null )
					fVolumeSecondSize = oVolumeSecond.size_get();
				
				var oVector = _oGame.positionDistance_get().delta_get( 
					oMobility.position_get(),
					oVolume.position_get()
				);
				
				if ( oVector.length_get() > ( oVolume.size_get() + fVolumeSecondSize ) )
					continue;
				
				oVector.length_set( (( oVolume.size_get() + fVolumeSecondSize ) - oVector.length_get() ) * 0.5  );
				
				oMobility.force_set( 'volume', oVector.x, oVector.y, false );
			}
			
		}
		
	} 
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		// on loop
		if( oSource == _oGame.onLoop )
			process();
		
		// on new mobile entity
		if ( oSource == _oGame.onEntityNew ) {
			var oVolume = cast(oSource.event_get(), Entity ).ability_get(Volume);
			if( oVolume != null ) {
				_loVolume.push( oVolume );
			}
		}
		
		// on new mobile entity
		if ( 
			oSource == _oGame.onAbilityDispose &&
			Std.is( oSource.event_get(), Volume)
		) {
			var oVolume = cast(oSource.event_get(), Volume );
			_loVolume.remove( oVolume );
		}
	}
}