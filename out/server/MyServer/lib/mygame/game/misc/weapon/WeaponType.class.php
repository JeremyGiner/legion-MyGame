<?php

class mygame_game_misc_weapon_WeaponType implements mygame_game_misc_weapon_IWeaponType{
	public function __construct($eType, $fPower, $fSpeed, $fRangeMax) {
		if(!php_Boot::$skip_constructor) {
		$this->_eType = $eType;
		$this->_fPower = $fPower;
		$this->_fRangeMax = $fRangeMax;
		$this->_fSpeed = Math::round(Math::max(1, $fSpeed));
	}}
	public $_eType;
	public $_fPower;
	public $_fRangeMax;
	public $_fSpeed;
	public function damageType_get() {
		return $this->_eType;
	}
	public function power_get() {
		return $this->_fPower;
	}
	public function rangeMax_get() {
		return $this->_fRangeMax;
	}
	public function speed_get() {
		return $this->_fSpeed;
	}
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
		if($oTarget->ability_get(_hx_qtype("mygame.game.ability.Health")) === null) {
			return false;
		}
		if(!$this->_inRange_check($oWeapon, $oTarget)) {
			return false;
		}
		return true;
	}
	public function _inRange_check($oWeapon, $oUnit) {
		return space_Vector2i::distance($oWeapon->unit_get()->ability_get(_hx_qtype("mygame.game.ability.Position")), $oUnit->ability_get(_hx_qtype("mygame.game.ability.Position"))) <= $this->_fRangeMax;
	}
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->__dynamics[$m]) && is_callable($this->__dynamics[$m]))
			return call_user_func_array($this->__dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call <'.$m.'>');
	}
	function __toString() { return 'mygame.game.misc.weapon.WeaponType'; }
}
