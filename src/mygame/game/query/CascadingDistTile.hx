package mygame.game.query;
import legion.entity.Entity;
import mygame.game.ability.Position;
import utils.CascadingValue;
import utils.IntTool;

/**
 * ...
 * @author GINER Jérémy
 */
class CascadingDistTile extends CascadingValue<Int> {

	var _oEntity0 :Entity;
	var _oEntity1 :Entity;
	
	public function new( oEntity0 :Entity, oEntity1 :Entity ) {
		_oEntity0 = oEntity0;
		_oEntity1 = oEntity1;
		
		var oPos0 :Position = cast _oEntity0.abilityMap_get().get('mygame.game.ability.Position');
		var oPos1 :Position = cast _oEntity1.abilityMap_get().get('mygame.game.ability.Position');
		
		super( [
			oPos0.onUpdateTile,
			oPos1.onUpdateTile
		] );
	}
	
	override function _update() {
		
		var oPos0 :Position = cast _oEntity0.abilityMap_get().get('mygame.game.ability.Position');
		var oPos1 :Position = cast _oEntity1.abilityMap_get().get('mygame.game.ability.Position');
		var dx = IntTool.abs( oPos0.tile_get().x_get() - oPos1.tile_get().x_get() );
		var dy = IntTool.abs( oPos0.tile_get().y_get() - oPos1.tile_get().y_get() );
		
		if ( oPos0 == null || oPos1 == null )
			_oValue = null;
		
		_oValue = IntTool.max( dx, dy );
	}
}