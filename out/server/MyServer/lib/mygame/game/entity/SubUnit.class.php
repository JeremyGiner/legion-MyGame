<?php

class mygame_game_entity_SubUnit extends mygame_game_entity_Unit {
	public function __construct($oGame, $oPlayer, $oPosition, $oPlatoon = null) { if(!php_Boot::$skip_constructor) {
		parent::__construct($oGame,$oPlayer,$oPosition);
		if($oPlatoon === null) {
			$this->_ability_add(new mygame_game_ability_Platoon($this));
		} else {
			$this->_ability_add($oPlatoon);
		}
	}}
	function __toString() { return 'mygame.game.entity.SubUnit'; }
}
