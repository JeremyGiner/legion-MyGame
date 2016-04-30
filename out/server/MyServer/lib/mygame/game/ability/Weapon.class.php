<?php

class mygame_game_ability_Weapon extends mygame_game_ability_UnitAbility {
	public function __construct($oOwner, $oType) {
		if(!php_Boot::$skip_constructor) {
		$this->_oTarget = null;
		parent::__construct($oOwner);
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
	public function target_suggest($oTarget) {
		if($this->_oTarget !== null || !$this->target_check($oTarget)) {
			return false;
		}
		$this->_oTarget = $oTarget;
		return true;
	}
	public function _fire() {
		$this->onFire->dispatch($this);
		$this->_oCooldown->reset();
		$oHealth = $this->_oTarget->ability_get(_hx_qtype("mygame.game.ability.Health"));
		$oHealth->damage($this->_oType->power_get(), $this->_oType->damageType_get());
	}
	public function _target_update() {
		if(!$this->target_check($this->_oTarget)) {
			$this->_oTarget = null;
		}
	}
	public function target_check($oTarget) {
		return $this->_oType->target_check($this, $oTarget);
	}
	public function swipe_target() {
		$this->_target_update();
		if($this->_oTarget !== null) {
			return;
		}
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
	public function fire() {
		if($this->_oCooldown->expired_check() && $this->_oTarget !== null) {
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
