<?php

class mygame_game_utils_validatorentity_ValiInRangeEntity implements mygame_game_utils_IValidatorEntity{
	public function __construct($oEntity, $fRadius) {
		if(!php_Boot::$skip_constructor) {
		$this->_oEntity = $oEntity;
		$this->_fRadius = $fRadius;
		$this->_oDistCache = $this->_oEntity->game_get()->singleton_get(_hx_qtype("mygame.game.query.EntityDistance"));
	}}
	public $_oEntity;
	public $_fRadius;
	public $_oDistCache;
	public function distCache_get() {
		return $this->_oDistCache;
	}
	public function entity_get() {
		return $this->_oEntity;
	}
	public function validate($oEntity) {
		return $this->_oDistCache->distanceSqed_get($this->_oEntity, $oEntity)->get() <= $this->_fRadius * $this->_fRadius;
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
	function __toString() { return 'mygame.game.utils.validatorentity.ValiInRangeEntity'; }
}
