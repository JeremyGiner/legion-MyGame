<?php

class mygame_game_query_CascadingDistSqred extends utils_CascadingValue {
	public function __construct($oEntity0, $oEntity1) {
		if(!php_Boot::$skip_constructor) {
		$this->_oEntity0 = $oEntity0;
		$this->_oEntity1 = $oEntity1;
		$oPos0 = $this->_oEntity0->abilityMap_get()->get("mygame.game.ability.Position");
		$oPos1 = $this->_oEntity1->abilityMap_get()->get("mygame.game.ability.Position");
		parent::__construct((new _hx_array(array($oPos0->onUpdate, $oPos1->onUpdate))));
	}}
	public $_oEntity0;
	public $_oEntity1;
	public function _update() {
		$oPos0 = $this->_oEntity0->abilityMap_get()->get("mygame.game.ability.Position");
		$oPos1 = $this->_oEntity1->abilityMap_get()->get("mygame.game.ability.Position");
		if($oPos0 === null || $oPos1 === null) {
			$this->_oValue = null;
		}
		$this->_oValue = $oPos0->distanceSqed_get($oPos1);
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
	function __toString() { return 'mygame.game.query.CascadingDistSqred'; }
}
