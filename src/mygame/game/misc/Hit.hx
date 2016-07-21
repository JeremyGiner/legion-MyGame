package mygame.game.misc;
import legion.entity.Entity;
import mygame.game.misc.weapon.EDamageType;

/**
 * ...
 * @author GINER Jérémy
 */
class Hit implements IHit {
	
	var _iDamage :Int;
	var _iTargetId :Int;
	var _oDamageType :EDamageType;
	
	public function new(
		iTargetId :Int,
		iDamage :Int,
		oDamageType :EDamageType
	) {
		_iTargetId = iTargetId;
		_iDamage = iDamage;
		_oDamageType = oDamageType;
	}
	
	public function damage_get() {
		return _iDamage;
	}
	public function targetId_get() {
		return _iTargetId;
	}
	public function damageType_get() {
		return _oDamageType;
	}
}