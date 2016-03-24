<?php

class mygame_game_ability_Health extends mygame_game_ability_UnitAbility {
	public function __construct($oUnit, $bArmored = null, $fMax = null, $fCurrent = null) {
		if(!php_Boot::$skip_constructor) {
		if($fCurrent === null) {
			$fCurrent = 100;
		}
		if($fMax === null) {
			$fMax = 100;
		}
		if($bArmored === null) {
			$bArmored = false;
		}
		parent::__construct($oUnit);
		$this->_fCurrent = $fCurrent;
		$this->_fMax = $fMax;
		$this->_bArmored = $bArmored;
		$this->onUpdate = new trigger_EventDispatcherTree($oUnit->mygame_get()->onHealthAnyUpdate);
	}}
	public $_fCurrent;
	public $_fMax;
	public $_bArmored;
	public $onUpdate;
	public function get() {
		return $this->_fCurrent;
	}
	public function max_get() {
		return $this->_fMax;
	}
	public function armored_check() {
		return $this->_bArmored;
	}
	public function max_set($fHealthMax) {
		$this->_fMax = $fHealthMax;
		$this->onUpdate->dispatch($this);
	}
	public function set($fHealthCurrent) {
		$this->_fCurrent = Math::min(Math::max($fHealthCurrent, 0), $this->_fMax);
		$this->onUpdate->dispatch($this);
	}
	public function percent_set($fPercent) {
		$this->set($fPercent * $this->_fMax);
	}
	public function percent_get() {
		return $this->_fCurrent / $this->_fMax;
	}
	public function damage($fDamage, $eDamageType) {
		if($this->_bArmored && $eDamageType === mygame_game_misc_weapon_EDamageType::$Bullet) {
			return;
		}
		$this->set($this->get() - $fDamage);
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
	function __toString() { return 'mygame.game.ability.Health'; }
}
