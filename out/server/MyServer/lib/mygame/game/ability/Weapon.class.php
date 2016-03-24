<?php

class mygame_game_ability_Weapon extends mygame_game_ability_UnitAbility implements trigger_ITrigger{
	public function __construct($oOwner, $oType) {
		if(!php_Boot::$skip_constructor) {
		$this->_oTarget = null;
		parent::__construct($oOwner);
		$this->_oType = $oType;
		$this->_oCooldown = new mygame_game_utils_Timer($this->_oUnit->game_get(), $this->_oType->speed_get(), false);
		$this->_oCooldown->reset();
		$this->onFire = new trigger_EventDispatcher2();
		$this->_oProcess = $this->_oUnit->mygame_get()->oWeaponProcess;
		$this->_oProcess->onTargeting->attach($this);
		$this->_oProcess->onFiring->attach($this);
	}}
	public $_oType;
	public $_oTarget;
	public $_oCooldown;
	public $_oProcess;
	public $onFire;
	public function rangeMax_get() {
		return $this->_oType->rangeMax_get();
	}
	public function cooldown_get() {
		return $this->_oCooldown;
	}
	public function target_set($oTarget) {
		$this->_oTarget = $oTarget;
	}
	public function target_suggest($oTarget) {
		if($this->_oTarget !== null || !$this->target_check($oTarget)) {
			return false;
		}
		$this->target_set($oTarget);
		return true;
	}
	public function target_get() {
		return $this->_oTarget;
	}
	public function _fire() {
		$this->onFire->dispatch($this);
		if($this->_oTarget === null) {
			return;
		}
		$this->_oCooldown->reset();
		$oHealth = $this->_oTarget->ability_get(_hx_qtype("mygame.game.ability.Health"));
		$oHealth->damage($this->_oType->power_get(), $this->_oType->damageType_get());
	}
	public function target_update() {
		if(!$this->target_check($this->_oTarget)) {
			$this->target_set(null);
		}
	}
	public function swipe_target() {
		$this->target_update();
		{
			$_g = 0;
			$_g1 = $this->_oUnit->mygame_get()->entity_get_all();
			while($_g < $_g1->length) {
				$oTarget = $_g1[$_g];
				++$_g;
				if(Std::is($oTarget, _hx_qtype("mygame.game.entity.Unit"))) {
					$this->target_suggest($oTarget);
				}
				unset($oTarget);
			}
		}
	}
	public function target_check($oTarget) {
		return $this->_oType->target_check($this, $oTarget);
	}
	public function trigger($oSource) {
		if($oSource === $this->_oProcess->onTargeting) {
			$this->swipe_target();
		}
		if($oSource === $this->_oProcess->onFiring) {
			if($this->_oCooldown->expired_check()) {
				$this->_fire();
			}
		}
	}
	public function dispose() {
		$this->_oProcess->onTargeting->remove($this);
		$this->_oProcess->onFiring->remove($this);
		parent::dispose();
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
