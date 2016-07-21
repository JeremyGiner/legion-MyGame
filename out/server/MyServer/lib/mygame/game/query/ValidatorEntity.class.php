<?php

class mygame_game_query_ValidatorEntity implements mygame_game_utils_IValidatorEntity{
	public function __construct($mParameter) {
		if(!php_Boot::$skip_constructor) {
		$this->_mParameter = $mParameter;
		if($this->_mParameter->get("ability") !== null) {
			$v = Type::getClassName($this->_mParameter->get("ability"));
			$this->_mParameter->set("ability", $v);
			$v;
		}
	}}
	public $_mParameter;
	public function validate($oEntity) {
		if(null == $this->_mParameter) throw new HException('null iterable');
		$__hx__it = $this->_mParameter->keys();
		while($__hx__it->hasNext()) {
			unset($sKey);
			$sKey = $__hx__it->next();
			switch($sKey) {
			case "class":{
				$_oType = $this->_mParameter->get("class");
				if(!Std::is($oEntity, $_oType)) {
					return false;
				}
			}break;
			case "ability":{
				if($oEntity->abilityMap_get()->get($this->_mParameter->get("ability")) === null) {
					return false;
				}
			}break;
			case "player":{
				$oLoyalty = $oEntity->ability_get(_hx_qtype("mygame.game.ability.Loyalty"));
				if($oLoyalty === null || $oLoyalty->owner_get() === null || !_hx_equal($oLoyalty->owner_get(), $this->_mParameter->get("player"))) {
					return false;
				}
			}break;
			default:{
				throw new HException("unknown filter key \"" . _hx_string_or_null($sKey) . "\"");
			}break;
			}
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
	function __toString() { return 'mygame.game.query.ValidatorEntity'; }
}
