<?php

class mygame_game_action_UnitOrderMove implements mygame_game_action_IAction{
	public function __construct($oUnit, $oDestination) {
		if(!php_Boot::$skip_constructor) {
		$this->_oUnit = $oUnit;
		$this->_oDestination = $oDestination;
	}}
	public $_oDestination;
	public $_oUnit;
	public function unit_get() {
		return $this->_oUnit;
	}
	public function direction_get() {
		return $this->_oDestination;
	}
	public function exec($oGame) {
		if(!$this->check($oGame)) {
			throw new HException("invalid input");
		}
		$oPlatoon = $this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Platoon"));
		if($oPlatoon !== null) {
			$this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Platoon"))->goal_set($this->_oDestination);
			return;
		}
		$this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Guidance"))->goal_set($this->_oDestination);
	}
	public function check($oGame) {
		if($this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Guidance")) === null && $this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Platoon")) === null) {
			return false;
		}
		if(Std::is($this->_oUnit, _hx_qtype("mygame.game.entity.SubUnit"))) {
			return false;
		}
		return true;
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
	function __toString() { return 'mygame.game.action.UnitOrderMove'; }
}
