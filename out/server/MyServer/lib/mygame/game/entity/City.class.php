<?php

class mygame_game_entity_City extends mygame_game_entity_Building {
	public function __construct($oGame, $oPlayer, $oTile) { if(!php_Boot::$skip_constructor) {
		parent::__construct($oGame,$oPlayer,$oTile);
		$this->_ability_add(new mygame_game_ability_LoyaltyShift($this));
	}}
	function __toString() { return 'mygame.game.entity.City'; }
}
