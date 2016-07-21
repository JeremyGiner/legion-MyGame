package mygame.game.query;
import legion.entity.Entity;
import mygame.game.ability.Position;
import utils.CascadingValue;

/**
 * ...
 * @author GINER Jérémy
 */
class CascadingDistSqred extends CascadingValue<Float> {

	var _oEntity0 :Entity;
	var _oEntity1 :Entity;
	
	public function new( oEntity0 :Entity, oEntity1 :Entity ) {
		_oEntity0 = oEntity0;
		_oEntity1 = oEntity1;
		
		var oPos0 :Position = cast _oEntity0.abilityMap_get().get('mygame.game.ability.Position');
		var oPos1 :Position = cast _oEntity1.abilityMap_get().get('mygame.game.ability.Position');
		
		super( [
			oPos0.onUpdate,
			oPos1.onUpdate
		] );
	}
	
	override function _update() {
		var oPos0 :Position = cast _oEntity0.abilityMap_get().get('mygame.game.ability.Position');
		var oPos1 :Position = cast _oEntity1.abilityMap_get().get('mygame.game.ability.Position');
		
		if ( oPos0 == null || oPos1 == null )
			_oValue = null;
		
		_oValue = oPos0.distanceSqed_get( oPos1 );
	}
}