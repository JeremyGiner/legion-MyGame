<?php

class mygame_game_entity_Platoon extends mygame_game_entity_Unit {
	public function __construct($oGame, $oOwner, $oPosition) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oGame,$oOwner,$oPosition);
		$this->_ability_add(new mygame_game_ability_Platoon($this));
		$this->_ability_add(new mygame_game_ability_Volume($this, 0.4, 1));
		$this->_ability_add(new mygame_game_ability_PositionPlan($this, 1));
		$this->_ability_add(new mygame_game_ability_Mobility($this, 0.05));
		$this->_ability_add(new mygame_game_ability_Guidance($this));
		$this->_ability_add(new mygame_game_ability_LoyaltyShifter($this));
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
	function __toString() { return 'mygame.game.entity.Platoon'; }
}
