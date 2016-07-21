<?php

class mygame_game_utils_validatorentity_ValiAbility implements mygame_game_utils_IValidatorEntity{
	public function __construct($oClass) {
		if(!php_Boot::$skip_constructor) {
		$this->_sClassName = Type::getClassName($oClass);
	}}
	public $_sClassName;
	public function validate($oEntity) {
		return $oEntity->abilityMap_get()->get($this->_sClassName) !== null;
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
	function __toString() { return 'mygame.game.utils.validatorentity.ValiAbility'; }
}
