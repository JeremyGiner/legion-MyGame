<?php

class mygame_game_misc_weapon_WeaponTypeSoldier extends mygame_game_misc_weapon_WeaponType {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		parent::__construct(mygame_game_misc_weapon_EDamageType::$Bullet,5,10,5000);
	}}
	public function target_check($oWeapon, $oTarget) {
		if(parent::target_check($oWeapon,$oTarget) === false) {
			return false;
		}
		$oHealth = $oTarget->ability_get(_hx_qtype("mygame.game.ability.Health"));
		if($oHealth === null) {
			return false;
		}
		if($oHealth->armored_check()) {
			return false;
		}
		return true;
	}
	function __toString() { return 'mygame.game.misc.weapon.WeaponTypeSoldier'; }
}
