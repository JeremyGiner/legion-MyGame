<?php

class mygame_game_misc_weapon_TargetValidator implements mygame_game_utils_IValidatorEntity{
	public function __construct($oWeapon) {
		if(!php_Boot::$skip_constructor) {
		$this->_oWeapon = $oWeapon;
	}}
	public $_oWeapon;
	public function validate($oEntity) {
		return $this->_oWeapon->type_get()->target_check($this->_oWeapon, $oEntity);
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
	function __toString() { return 'mygame.game.misc.weapon.TargetValidator'; }
}
