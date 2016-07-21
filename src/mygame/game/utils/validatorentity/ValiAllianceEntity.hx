package mygame.game.utils.validatorentity;
import legion.entity.Entity;
import legion.entity.Player;
import mygame.game.ability.Loyalty;
import mygame.game.utils.IValidatorEntity;

/**
 * ...
 * @author GINER Jérémy
 */
class ValiAllianceEntity implements IValidatorEntity {

	var _oReference :Entity;
	var _oType :ALLIANCE;
	
	public function new( oEntity :Entity, oType :ALLIANCE = null ) {
		_oReference = oEntity;
		_oType = oType != null ? oType : ALLIANCE.ally;
	}
	
	public function validate( oEntity :Entity ) {
		// Check loyalty
		var oReferenceLoyalty :Loyalty = cast _oReference.abilityMap_get().get('mygame.game.ability.Loyalty');
		if ( oReferenceLoyalty == null ) return false;
		
		var oTargetLoyalty :Loyalty = cast oEntity.abilityMap_get().get('mygame.game.ability.Loyalty');
		if ( oTargetLoyalty == null ) return false;
		
		
		// Check if owned by opponent
		//trace( ' '+_oUnit.owner_get().alliance_get( oTarget.owner_get() ) );
		return oReferenceLoyalty.owner_get().alliance_get( oTargetLoyalty.owner_get() ) == _oType;
	}
}