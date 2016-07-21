<?php

class mygame_game_ability_Deploy extends mygame_game_ability_EntityAbility implements legion_IBehaviour{
	public function __construct($oEntity) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oEntity);
		$oPos = $this->_oEntity->ability_get(_hx_qtype("mygame.game.ability.Position"));
		$this->_oPosition = new space_Vector2i($oPos->x, $oPos->y);
	}}
	public $_oPosition;
	public $_fDeployed;
	public function percent_get() {
		return $this->_fDeployed;
	}
	public function processName_get() {
		return "deploy";
	}
	public function process() {
		$oPos = $this->_oEntity->ability_get(_hx_qtype("mygame.game.ability.Position"));
		if($this->_oPosition->x === $oPos->x && $this->_oPosition->y === $oPos->y) {
			$this->_fDeployed = Math::min($this->_fDeployed + 0.01, 1.0);
		} else {
			$this->_fDeployed = 0;
			$this->_oPosition = new space_Vector2i($oPos->x, $oPos->y);
		}
		if(!_hx_equal($this->_fDeployed, 1)) {
			$oWeapon = $this->_oEntity->ability_get(_hx_qtype("mygame.game.ability.Weapon"));
			$oWeapon->cooldown_get()->reset();
		}
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
	function __toString() { return 'mygame.game.ability.Deploy'; }
}
