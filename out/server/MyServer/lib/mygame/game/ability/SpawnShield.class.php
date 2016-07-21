<?php

class mygame_game_ability_SpawnShield extends mygame_game_ability_UnitAbility {
	public function __construct($oUnit, $iRadius = null) {
		if(!php_Boot::$skip_constructor) {
		if($iRadius === null) {
			$iRadius = 20000;
		}
		parent::__construct($oUnit);
		$this->_oPosition = $oUnit->ability_get(_hx_qtype("mygame.game.ability.Position"));
		if($this->_oPosition === null) {
			haxe_Log::trace("[ERROR]:ability dependency not respected.", _hx_anonymous(array("fileName" => "SpawnShield.hx", "lineNumber" => 23, "className" => "mygame.game.ability.SpawnShield", "methodName" => "new")));
		}
		$this->_iRadius = $iRadius;
		if($this->_iRadius < 0) {
			throw new HException("invalid radius.");
		}
	}}
	public $_oPosition;
	public $_iRadius;
	public function radius_get() {
		return $this->_iRadius;
	}
	public function effect_apply($oEntity) {
		if($oEntity->ability_get(_hx_qtype("mygame.game.ability.DivineShield")) !== null) {
			return;
		}
		$oEntity->ability_add(new mygame_game_ability_DivineShield($oEntity, $this));
	}
	public function target_check($oEntity) {
		$oLoyalty = $oEntity->ability_get(_hx_qtype("mygame.game.ability.Loyalty"));
		if($oLoyalty === null) {
			return false;
		}
		if((is_object($_t = $oLoyalty->owner_get()) && !($_t instanceof Enum) ? $_t !== $this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Loyalty"))->owner_get() : $_t != $this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Loyalty"))->owner_get())) {
			return false;
		}
		if($oEntity->ability_get(_hx_qtype("mygame.game.ability.Health")) === null) {
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
	function __toString() { return 'mygame.game.ability.SpawnShield'; }
}
