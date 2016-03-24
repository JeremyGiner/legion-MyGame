<?php

class mygame_game_ability_LoyaltyShifter extends mygame_game_ability_UnitAbility {
	public function __construct($oUnit) { if(!php_Boot::$skip_constructor) {
		parent::__construct($oUnit);
	}}
	function __toString() { return 'mygame.game.ability.LoyaltyShifter'; }
}
