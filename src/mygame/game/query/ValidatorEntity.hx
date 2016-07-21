package mygame.game.query;
import haxe.ds.StringMap;
import legion.entity.Entity;
import mygame.game.ability.Loyalty;
import mygame.game.utils.IValidatorEntity;

/**
 * A shorthand intended to be used with EntityQuery
 * @author GINER Jérémy
 */
class ValidatorEntity implements IValidatorEntity {

	var _mParameter :Map<String,Dynamic>;
	
	public function new( mParameter :Map<String,Dynamic> ) {
		_mParameter = mParameter;
		
		if ( _mParameter['ability'] != null )
			_mParameter['ability'] = Type.getClassName( _mParameter['ability'] );
	}
	
	public function validate( oEntity :Entity ) {
		for ( sKey in _mParameter.keys() ) {
			switch( sKey ) {
				case 'class' : 
					var _oType = _mParameter['class'];
					if ( !Std.is( oEntity, _oType) )
						return false;
				case 'ability' : 
					if ( oEntity.abilityMap_get().get( _mParameter['ability'] ) == null )
						return false;
				case 'player' :
					var oLoyalty = oEntity.ability_get(Loyalty);
					
					if ( 
						oLoyalty == null || 
						oLoyalty.owner_get() == null ||
						oLoyalty.owner_get() != _mParameter['player']
					)
						return false;
					
				default:
					throw('unknown filter key "'+sKey+'"');
			}
		}
		
		return true;
	}
	
}