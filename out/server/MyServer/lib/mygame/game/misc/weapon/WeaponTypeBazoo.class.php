<?php

class mygame_game_misc_weapon_WeaponTypeBazoo extends mygame_game_misc_weapon_WeaponType {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		parent::__construct(mygame_game_misc_weapon_EDamageType::$Shell,20,20,30000);
	}}
	function __toString() { return 'mygame.game.misc.weapon.WeaponTypeBazoo'; }
}
