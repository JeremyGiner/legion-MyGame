<?php

class mygame_game_utils_validatorentity_ValiInRangeEntityByTile implements mygame_game_utils_IValidatorEntity{
	public function __construct($oEntity, $fRadius) {
		if(!php_Boot::$skip_constructor) {
		$this->_oEntity = $oEntity;
		$this->_iTileDist = mygame_game_ability_Position::metric_unit_to_maptile(Math::ceil($fRadius)) + 1;
		$this->_oQueryDist = $oEntity->game_get()->singleton_get(_hx_qtype("mygame.game.query.EntityDistanceTile"));
	}}
	public $_oEntity;
	public $_iTileDist;
	public $_oQueryDist;
	public function entity_get() {
		return $this->_oEntity;
	}
	public function validate($oEntity) {
		return $this->_oQueryDist->data_get((new _hx_array(array($this->_oEntity, $oEntity))))->get() <= $this->_iTileDist;
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
	function __toString() { return 'mygame.game.utils.validatorentity.ValiInRangeEntityByTile'; }
}
