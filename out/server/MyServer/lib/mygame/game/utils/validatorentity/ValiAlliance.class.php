<?php

class mygame_game_utils_validatorentity_ValiAlliance implements mygame_game_utils_IValidatorEntity{
	public function __construct($oPlayer) {
		if(!php_Boot::$skip_constructor) {
		$this->_oPlayer = $oPlayer;
	}}
	public $_oPlayer;
	public function validate($oEntity) {
		return (is_object($_t = $oEntity->ability_get(_hx_qtype("mygame.game.ability.Loyalty"))->owner_get()) && !($_t instanceof Enum) ? $_t === $this->_oPlayer : $_t == $this->_oPlayer);
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
	function __toString() { return 'mygame.game.utils.validatorentity.ValiAlliance'; }
}
