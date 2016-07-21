package mygame.game.process;
import legion.entity.Entity;
import mygame.game.ability.DivineShield;
import mygame.game.ability.SpawnShield;
import mygame.game.MyGame;
import mygame.game.query.EntityQuery;
import mygame.game.query.EntityDistance;
import mygame.game.query.ValidatorEntity;
import trigger.IEventDispatcher;
import trigger.ITrigger;

/**
 * ...
 * @author GINER Jérémy
 */
class AuraProcess implements ITrigger {

	var _oGame :MyGame;
	var _oQuerySpawnShield :EntityQuery;
	var _oQueryDivineShield :EntityQuery;
	
	public function new( oGame :MyGame ) {
		_oGame = oGame;
		_oQuerySpawnShield = new EntityQuery( _oGame, new ValidatorEntity([ 'ability' => SpawnShield ]) );
		_oQueryDivineShield = new EntityQuery( _oGame, new ValidatorEntity([ 'ability' => DivineShield ]) );
		
		_oGame.onLoop.attach( this );
	}
	
	public function process() {
		
		// Collect expired
		var lExpired = new List<Entity>();
		for ( oEntity0 in _oQueryDivineShield.data_get(null) ) {
			if ( oEntity0.ability_get(DivineShield).expired_check() )
				lExpired.push( oEntity0 );
		}
		// Process expired
		for( oEntity in lExpired )
			oEntity.ability_remove(DivineShield);
		
		// Apply aura effect
		for ( oEntity0 in _oQuerySpawnShield.data_get(null) ) {
			var oSpawnShield = oEntity0.ability_get(SpawnShield);
			var l = _oGame.singleton_get(EntityDistance).entityList_get_byProximity( 
				oSpawnShield.unit_get(),	// Should be entity0
				oSpawnShield.radius_get()
			);
			
			// Apply effect tot each target
			for ( oEntity1 in l ) {
				
				// Filter invalid target
				if ( !oSpawnShield.target_check( oEntity1 ) )
					continue;
				
				oSpawnShield.effect_apply( oEntity1 );
			}
		}
	}
	
	public function trigger( oSource :IEventDispatcher ) {
		process();
	}
	
}