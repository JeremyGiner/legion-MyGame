<?php

class mygame_game_ability_DivineShield extends mygame_game_ability_UnitAbility {
	public function __construct($oUnit, $oSource) {
		if(!php_Boot::$skip_constructor) {
		$this->_oSource = $oSource;
		parent::__construct($oUnit);
	}}
	public $_oSource;
	public function source_get() {
		return $this->_oSource;
	}
	public function expired_check() {
		$fDistance = $this->_oUnit->mygame_get()->singleton_get(_hx_qtype("mygame.game.query.UnitDist"))->data_get((new _hx_array(array($this->_oUnit, $this->_oSource->unit_get()))));
		return $fDistance > $this->_oSource->radius_get();
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
	function __toString() { return 'mygame.game.ability.DivineShield'; }
}
