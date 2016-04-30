<?php

class mygame_game_misc_weapon_WeaponTypeSoldier extends mygame_game_misc_weapon_WeaponType {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		parent::__construct(mygame_game_misc_weapon_EDamageType::$Bullet,5,10,5000);
	}}
	public function target_check($oWeapon, $oTarget) {
		if($oTarget === null) {
			return false;
		}
		if($oTarget === $oWeapon->unit_get()) {
			return false;
		}
		if($oTarget->game_get() === null) {
			return false;
		}
		if($oWeapon->unit_get()->owner_get()->alliance_get($oTarget->owner_get()) === "ally") {
			return false;
		}
		$oHealth = $oTarget->ability_get(_hx_qtype("mygame.game.ability.Health"));
		if($oHealth === null) {
			return false;
		}
		if($oHealth->armored_check()) {
			return false;
		}
		if(!$this->_inRange_check($oWeapon, $oTarget)) {
			return false;
		}
		return true;
	}
	function __toString() { return 'mygame.game.misc.weapon.WeaponTypeSoldier'; }
}
