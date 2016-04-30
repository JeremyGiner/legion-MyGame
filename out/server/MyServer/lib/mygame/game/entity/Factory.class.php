<?php

class mygame_game_entity_Factory extends mygame_game_entity_Building {
	public function __construct($oGame, $oPlayer, $oTile) { if(!php_Boot::$skip_constructor) {
		parent::__construct($oGame,$oPlayer,$oTile);
		$this->_ability_add(new mygame_game_ability_BuilderFactory($this));
		$this->_ability_add(new mygame_game_ability_SpawnShield($this, null));
	}}
	function __toString() { return 'mygame.game.entity.Factory'; }
}
