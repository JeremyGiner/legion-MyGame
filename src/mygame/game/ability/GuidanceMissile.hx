package mygame.game.ability;

import collider.CollisionCheckerPost;
import legion.ability.IAbility;
import legion.entity.Entity;
import math.Limit;
import mygame.game.entity.WorldMap;
import mygame.game.entity.Unit;
import mygame.game.ability.Mobility;
import mygame.game.ability.Volume;
import mygame.game.utils.PathFinderFlowField in Pathfinder;
import mygame.game.tile.Tile;
import mygame.game.tile.*;
import space.AlignedAxisBox;
import space.Vector3;
import space.Vector2i;
import utils.IntTool;
import utils.ListTool;

/**
 * Ability for an entity to move toward a target entity
 * @author GINER Jérémy
 */

class GuidanceMissile extends Guidance {
	
	var _iTargetId :Int;
	var _oEntity :Entity;
	
	// Cache
	var _oTarget :Entity;
	
//______________________________________________________________________________
//	Constructor

	public function new( oEntity :Entity, iTargetId :Int ) :Void {
		super( cast oEntity );
		_oEntity = oEntity;
		_iTargetId = iTargetId;
	}
	
//______________________________________________________________________________
//	Accessor

	public function target_get() :Entity {
		
		// Check id
		if ( _iTargetId == -1 )
			return null;
		
		// Get target
		var oTarget = _oEntity.game_get().entity_get( _iTargetId );
		
		// Check target
		if ( oTarget == null || oTarget.ability_get(Position) == null )
			_iTargetId = -1;
		
		// Cache update
		_oTarget = oTarget;
		
		return oTarget;
	}
	
//______________________________________________________________________________
//	Process

	override public function process() :Void {
		
		var oTarget = target_get();
		
		// Case : no goal
		if ( oTarget == null ){
			_oEntity.ability_get(Mobility).force_set( 'self', 0, 0, true ); 
			return;
		}
		
		// Set mobility direction
		var oVector = _vector_get();
		_oMobility.force_set( 'self', oVector.x, oVector.y, true );
	}
	
	
//______________________________________________________________________________
//	Sub-routine

	override public function _vector_get() :Vector2i {
		// Get delta between target position and owner position
		var oDelta = _oTarget.ability_get(Position).clone();
		oDelta.vector_add( _oEntity.ability_get(Position).clone().mult( -1) );
		
		return oDelta;
	}

}