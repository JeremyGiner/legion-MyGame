<?php

class mygame_game_entity_Soldier extends mygame_game_entity_Unit {
	public function __construct($oGame, $oPlayer, $oPosition) { if(!php_Boot::$skip_constructor) {
		parent::__construct($oGame,$oPlayer,$oPosition);
		$this->_ability_add(new mygame_game_ability_PositionPlan($this, 2));
		$this->_ability_add(new mygame_game_ability_Mobility($this, 1000));
		$this->_ability_add(new mygame_game_ability_Guidance($this));
		$this->_ability_add(new mygame_game_ability_Health($this, null, null, null));
		$this->_ability_add(new mygame_game_ability_Weapon($this, $oGame->singleton_get(_hx_qtype("mygame.game.misc.weapon.WeaponTypeSoldier"))));
		$this->_ability_add(new mygame_game_ability_LoyaltyShifter($this));
	}}
	function __toString() { return 'mygame.game.entity.Soldier'; }
}
