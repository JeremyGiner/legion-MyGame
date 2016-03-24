<?php

class mygame_game_entity_Copter extends mygame_game_entity_Unit {
	public function __construct($oGame, $oPlayer, $oPosition) { if(!php_Boot::$skip_constructor) {
		parent::__construct($oGame,$oPlayer,$oPosition);
		$this->_ability_add(new mygame_game_ability_PositionPlan($this, 0));
		$this->_ability_add(new mygame_game_ability_Mobility($this, 0.05));
		$this->_ability_add(new mygame_game_ability_Volume($this, 0.1, null));
		$this->_ability_add(new mygame_game_ability_Guidance($this));
		$this->_ability_add(new mygame_game_ability_Weapon($this, $oGame->singleton_get(_hx_qtype("mygame.game.misc.weapon.WeaponTypeBazoo"))));
		$this->_ability_add(new mygame_game_ability_Health($this, null, null, null));
		$this->_ability_add(new mygame_game_ability_LoyaltyShifter($this));
		$this->ability_get(_hx_qtype("mygame.game.ability.Mobility"))->orientationSpeed_set(0.05);
	}}
	function __toString() { return 'mygame.game.entity.Copter'; }
}
