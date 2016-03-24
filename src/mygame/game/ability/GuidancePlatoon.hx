package mygame.game.ability;

import collider.CollisionCheckerPost;
import legion.ability.IAbility;
import math.Limit;
import mygame.game.entity.WorldMap;
import mygame.game.entity.Unit;
import mygame.game.ability.Mobility;
import mygame.game.ability.Volume;
import mygame.game.utils.PathFinderFlowField in Pathfinder;
import mygame.game.tile.Tile;
import mygame.game.tile.*;
import space.AlignedAxisBox;
import space.Vector2i;
import space.Vector3;

/**
 * Ability for a unit to walk a path toward a valid position using his Mobility ability
 * @author GINER Jérémy
 */

class GuidancePlatoon extends Guidance {
	
//______________________________________________________________________________
//	Constructor

	public function new( oUnit :Unit ) :Void {
		super( oUnit );
		
		
	}

//______________________________________________________________________________
//	Accessor

	override public function goal_set( oDestination :Vector2i ) {
		
		super.goal_set( oDestination );
		
		if ( _oGoal == null )
			return;
		
		// Platoon guidance
		var oPlatoon :Platoon = _oUnit.ability_get(Platoon);
		if ( oPlatoon == null ) 
			throw 'Error';
			
		var oVolume = _oUnit.ability_get( Volume );
		if ( oVolume == null ) 
			throw 'Error';
			
		var aUnit = oPlatoon.subUnit_get();
		for ( i in 0...aUnit.length ) {
			var oGuidance = aUnit[i].ability_get(Guidance);
			
			if ( oGuidance == null )
				continue;
				
			var oOffset = oPlatoon.offset_get( i );
			if ( _oGoal != null ) {
				oOffset = oPlatoon.offset_get( i );
				oOffset.mult( oVolume.size_get() );	//TODO
				oOffset.vector_add( _oGoal );
				oOffset.add( -oVolume.size_get(), -oVolume.size_get());
			}
			
			oGuidance.goal_set( oOffset );
		}
	}
	


}