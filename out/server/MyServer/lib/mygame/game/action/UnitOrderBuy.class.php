<?php

class mygame_game_action_UnitOrderBuy implements mygame_game_action_IAction{
	public function __construct($oUnit, $iOfferIndex) {
		if(!php_Boot::$skip_constructor) {
		$this->_oUnit = $oUnit;
		$this->_iOfferIndex = $iOfferIndex;
	}}
	public $_iOfferIndex;
	public $_oUnit;
	public function unit_get() {
		return $this->_oUnit;
	}
	public function offerIndex_get() {
		return $this->_iOfferIndex;
	}
	public function exec($oGame) {
		if(!$this->check($oGame)) {
			throw new HException("invalid input");
		}
		$this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.BuilderFactory"))->buy($this->_iOfferIndex);
	}
	public function check($oGame) {
		if($this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.BuilderFactory")) === null) {
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
	function __toString() { return 'mygame.game.action.UnitOrderBuy'; }
}
