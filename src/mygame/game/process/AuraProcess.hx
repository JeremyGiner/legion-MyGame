package mygame.game.process;
import mygame.game.ability.DivineShield;
import mygame.game.ability.SpawnShield;
import mygame.game.MyGame;
import mygame.game.query.EntityQuery;
import mygame.game.query.UnitDist;

/**
 * ...
 * @author GINER Jérémy
 */
class AuraProcess {

	var _oGame :MyGame;
	var _oQuerySpawnShield :EntityQuery;
	var _oQueryDivineShield :EntityQuery;
	
	public function new( oGame :MyGame ) {
		_oGame = oGame;
		_oQuerySpawnShield = new EntityQuery( _oGame, [ 'ability' => SpawnShield ] );
		_oQueryDivineShield = new EntityQuery( _oGame, [ 'ability' => DivineShield ] );
	}
	
	public function process() {
		
		// Effect expire
		for ( oEntity0 in _oQueryDivineShield.data_get(null) ) {
			if ( oEntity0.ability_get(DivineShield).expired_check() )
				oEntity0.ability_remove(DivineShield);
		}
		
		// Apply aura effect
		for ( oEntity0 in _oQuerySpawnShield.data_get(null) ) {
			var oSpawnShield = oEntity0.ability_get(SpawnShield);
			var l = _oGame.singleton_get(UnitDist).entityList_get_byProximity( 
				oSpawnShield.unit_get(),	// Should be entity0
				oSpawnShield.radius_get()
			);
			
			// Apply effect tot each target
			for ( oEntity1 in l ) {
				oSpawnShield.apply_effect( oEntity1 );
			}
		}
	}
}