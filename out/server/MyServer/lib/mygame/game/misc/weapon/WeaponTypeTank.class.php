<?php

class mygame_game_misc_weapon_WeaponTypeTank extends mygame_game_misc_weapon_WeaponType {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		parent::__construct(mygame_game_misc_weapon_EDamageType::$Shell,100,30,10000);
	}}
	function __toString() { return 'mygame.game.misc.weapon.WeaponTypeTank'; }
}
