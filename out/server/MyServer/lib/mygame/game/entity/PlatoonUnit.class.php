<?php

class mygame_game_entity_PlatoonUnit extends legion_entity_Entity {
	public function __construct($oGame, $oOwner, $oPosition) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oGame);
		$this->_ability_add(new mygame_game_ability_Loyalty($this, $oOwner));
		$oAbility = new mygame_game_ability_Platoon($this);
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
