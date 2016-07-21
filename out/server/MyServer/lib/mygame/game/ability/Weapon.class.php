<?php

class mygame_game_ability_Weapon extends mygame_game_ability_UnitAbility {
	public function __construct($oOwner, $oType) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oOwner);
		$this->_oTarget = null;
		$this->_oType = $oType;
		$this->_oCooldown = new mygame_game_utils_Timer($this->_oUnit->game_get(), $this->_oType->speed_get(), false);
		$this->_oCooldown->reset();
		$this->onFire = new trigger_EventDispatcher2();
	}}
	public $_oType;
	public $_oTarget;
	public $_oCooldown;
	public $onFire;
	public function rangeMax_get() {
		return $this->_oType->rangeMax_get();
	}
	public function cooldown_get() {
		return $this->_oCooldown;
	}
	public function target_get() {
		$this->_target_update();
		return $this->_oTarget;
	}
	public function type_get() {
		return $this->_oType;
	}
	public function target_suggest($oTarget) {
		if($this->_oTarget !== null || !$this->_oType->target_check($this, $oTarget)) {
			return false;
		}
		return true;
	}
	public function target_set($oTarget) {
		$this->_oTarget = $oTarget;
	}
	public function _fire() {
		$this->onFire->dispatch($this);
		$this->_oCooldown->reset();
		if((is_object($_t = $this->_oType->damageType_get()) && !($_t instanceof Enum) ? $_t === mygame_game_misc_weapon_EDamageType::$Shell : $_t == mygame_game_misc_weapon_EDamageType::$Shell)) {
			$oPos = $this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Position"));
			$oTargetPos = $this->_oTarget->ability_get(_hx_qtype("mygame.game.ability.Position"));
			$this->_oUnit->game_get()->entity_add(new mygame_game_entity_Projectile($this->_oUnit->game_get(), $oPos->x, $oPos->y, $oTargetPos->hclone()));
			return;
		}
		$this->_oUnit->game_get()->singleton_get(_hx_qtype("mygame.game.process.WeaponProcess"))->hit_add(new mygame_game_misc_Hit($this->_oTarget->identity_get(), Math::round($this->_oType->power_get()), $this->_oType->damageType_get()));
	}
	public function _target_update() {
		if(!$this->_oType->target_check($this, $this->_oTarget)) {
			$this->_oTarget = null;
		}
	}
	public function fire() {
		if($this->_oCooldown->expired_check() && $this->target_get() !== null) {
			$this->_fire();
		}
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
	function __toString() { return 'mygame.game.ability.Weapon'; }
}
