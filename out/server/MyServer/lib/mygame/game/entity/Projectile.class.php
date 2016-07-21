<?php

class mygame_game_entity_Projectile extends legion_entity_Entity {
	public function __construct($oGame, $x, $y, $oTarget) { if(!php_Boot::$skip_constructor) {
		parent::__construct($oGame);
		$this->_ability_add(new mygame_game_ability_Position($this, $oGame->map_get(), $x, $y));
	}}
	function __toString() { return 'mygame.game.entity.Projectile'; }
}
