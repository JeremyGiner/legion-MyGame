<?php

interface mygame_game_misc_weapon_IWeaponType {
	function damageType_get();
	function power_get();
	function rangeMax_get();
	function speed_get();
	function target_check($oWeapon, $oTarget);
}
