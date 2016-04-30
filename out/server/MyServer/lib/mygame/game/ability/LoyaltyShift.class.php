<?php

class mygame_game_ability_LoyaltyShift extends mygame_game_ability_UnitAbility {
	public function __construct($oUnit) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oUnit);
		$this->_fLoyalty = 1;
		$this->_oChallenger = $this->_oUnit->owner_get();
		if($this->_oChallenger === null) {
			$this->_fLoyalty = 0;
		}
	}}
	public $_fLoyalty;
	public $_oChallenger;
	public function radius_get() {
		return 10000;
	}
	public function loyalty_get() {
		return $this->_fLoyalty;
	}
	public function challenger_get() {
		return $this->_oChallenger;
	}
	public function challenger_set($oPlayer) {
		$this->_oChallenger = $oPlayer;
	}
	public function loyalty_increase() {
		$this->_fLoyalty += mygame_game_ability_LoyaltyShift::$_fStep;
		if($this->_fLoyalty >= 0.5) {
			$this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Loyalty"))->owner_set($this->_oChallenger);
		}
		$this->_fLoyalty = Math::min($this->_fLoyalty, 1);
	}
	public function loyalty_decrease() {
		$this->_fLoyalty -= mygame_game_ability_LoyaltyShift::$_fStep;
		if($this->_fLoyalty < 0.5) {
			$this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Loyalty"))->owner_set(null);
		}
		$this->_fLoyalty = Math::max($this->_fLoyalty, 0);
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
	static $_fStep = 0.01;
	function __toString() { return 'mygame.game.ability.LoyaltyShift'; }
}
