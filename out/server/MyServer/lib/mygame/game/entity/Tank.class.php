<?php

class mygame_game_entity_Tank extends mygame_game_entity_Unit {
	public function __construct($oGame, $oPlayer, $oPosition) { if(!php_Boot::$skip_constructor) {
		parent::__construct($oGame,$oPlayer,$oPosition);
		$this->_ability_add(new mygame_game_ability_PositionPlan($this, 1));
		$this->_ability_add(new mygame_game_ability_Volume($this, 2000, 0.45));
		$this->_ability_add(new mygame_game_ability_Mobility($this, 200));
		$this->_ability_add(new mygame_game_ability_Guidance($this));
		$this->_ability_add(new mygame_game_ability_Weapon($this, $oGame->singleton_get(_hx_qtype("mygame.game.misc.weapon.WeaponTypeBazoo"))));
		$this->_ability_add(new mygame_game_ability_Health($this, true, null, null));
	}}
	function __toString() { return 'mygame.game.entity.Tank'; }
}
