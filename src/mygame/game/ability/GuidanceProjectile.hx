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

class GuidanceProjectile extends Guidance {
	
	var _oTarget :Vector2i;
	var _oEntity :Entity;
	
//______________________________________________________________________________
//	Constructor

	public function new( oEntity :Entity, oTarget :Vector2i ) :Void {
		super( cast oEntity );
		_oEntity = oEntity;
		_oTarget = oTarget;
	}
	
//______________________________________________________________________________
//	Process

	override public function process() :Void {
		// Get delta between target position and owner position
		var oDelta = _oTarget.clone();
		oDelta.vector_add( _oEntity.ability_get(Position).clone().mult( -1) );
		
		// Case : detonate
		if ( oDelta.x == 0 && oDelta.y == 0 ) {
			_oEntity.game_get().entity_remove( _oEntity ); 
			return;
		}
		
		_oMobility.force_set( 'self', oDelta.x, oDelta.y, true );
	}
	

}