<?php

class mygame_game_entity_PlatoonUnit extends mygame_game_entity_Unit {
	public function __construct($oGame, $oOwner, $oPosition) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oGame,$oOwner,$oPosition);
		$oAbility = new mygame_game_ability_Platoon($this, $oPosition);
		$this->_ability_add($oAbility);
		$this->_moAbility->set(Type::getClassName(_hx_qtype("mygame.game.ability.Guidance")), $oAbility);
	}}
	public $_aSubUnit;
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
	function __toString() { return 'mygame.game.entity.PlatoonUnit'; }
}
