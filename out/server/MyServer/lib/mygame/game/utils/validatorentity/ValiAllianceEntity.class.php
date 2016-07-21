<?php

class mygame_game_utils_validatorentity_ValiAllianceEntity implements mygame_game_utils_IValidatorEntity{
	public function __construct($oEntity, $oType = null) {
		if(!php_Boot::$skip_constructor) {
		$this->_oReference = $oEntity;
		if($oType !== null) {
			$this->_oType = $oType;
		} else {
			$this->_oType = legion_entity_ALLIANCE::$ally;
		}
	}}
	public $_oReference;
	public $_oType;
	public function validate($oEntity) {
		$oReferenceLoyalty = $this->_oReference->abilityMap_get()->get("mygame.game.ability.Loyalty");
		if($oReferenceLoyalty === null) {
			return false;
		}
		$oTargetLoyalty = $oEntity->abilityMap_get()->get("mygame.game.ability.Loyalty");
		if($oTargetLoyalty === null) {
			return false;
		}
		return (is_object($_t = $oReferenceLoyalty->owner_get()->alliance_get($oTargetLoyalty->owner_get())) && !($_t instanceof Enum) ? $_t === $this->_oType : $_t == $this->_oType);
	}
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->__dynamics[$m]) && is_callable($this->__dynamics[$m]))
			return call_user_func_array($this->__dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call <'.$m.'>');
	}
	function __toString() { return 'mygame.game.utils.validatorentity.ValiAllianceEntity'; }
}
