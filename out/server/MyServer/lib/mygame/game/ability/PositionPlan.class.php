<?php

class mygame_game_ability_PositionPlan extends mygame_game_ability_UnitAbility implements mygame_game_utils_IValidatorTile{
	public function __construct($oUnit, $iCodePlan) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oUnit);
		$this->_iCodePlan = $iCodePlan;
	}}
	public $_iCodePlan;
	public function check($oTile) {
		{
			$_g = $this->_iCodePlan;
			switch($_g) {
			case 0:{
				return true;
			}break;
			case 1:{
				return mygame_game_ability_PositionPlan::isLandWalkable($oTile);
			}break;
			case 2:{
				return mygame_game_ability_PositionPlan::isFootWalkable($oTile);
			}break;
			}
		}
		throw new HException("Invalid code plan : " . _hx_string_rec($this->_iCodePlan, ""));
		return false;
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
	static function isLandWalkable($oTile) {
		if($oTile === null) {
			return false;
		}
		if($oTile->type_get() === 0) {
			return false;
		}
		if($oTile->type_get() === 3) {
			return false;
		}
		if($oTile->map_get()->game_get()->query_get(_hx_qtype("mygame.game.query.CityTile"))->data_get($oTile)->length !== 0) {
			return false;
		}
		return true;
	}
	static function isFootWalkable($oTile) {
		if($oTile === null) {
			return false;
		}
		if($oTile->type_get() === 1) {
			return true;
		}
		if($oTile->type_get() === 4) {
			return true;
		}
		if($oTile->type_get() === 2) {
			return true;
		}
		return false;
	}
	function __toString() { return 'mygame.game.ability.PositionPlan'; }
}
