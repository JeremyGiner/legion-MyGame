<?php

class mygame_game_action_UnitOrderMove implements mygame_game_action_IAction{
	public function __construct($oUnit, $oDestination, $fAngle, $bStack = null) {
		if(!php_Boot::$skip_constructor) {
		if($bStack === null) {
			$bStack = false;
		}
		$this->_oUnit = $oUnit;
		$this->_fAngle = $fAngle;
		$this->_oDestination = $oDestination;
		$this->_bStack = $bStack;
	}}
	public $_oDestination;
	public $_fAngle;
	public $_oUnit;
	public $_bStack;
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
			if($this->_bStack) {
				$this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Platoon"))->waypoint_add($this->_oDestination, $this->_fAngle);
			} else {
				$this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Platoon"))->waypoint_set($this->_oDestination, $this->_fAngle);
			}
			return;
		}
		if($this->_bStack) {
			$this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Guidance"))->waypoint_add($this->_oDestination);
		} else {
			$this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Guidance"))->waypoint_set($this->_oDestination);
		}
	}
	public function check($oGame) {
		if($this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Guidance")) === null && $this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Platoon")) === null) {
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
