<?php

class mygame_game_entity_SubUnit extends mygame_game_entity_Unit {
	public function __construct($oParent, $oPosition) {
		if(!php_Boot::$skip_constructor) {
		$this->_oPlatoon = $oParent;
		$oGame = $this->_oPlatoon->game_get();
		parent::__construct($oGame,$this->_oPlatoon->owner_get(),$oPosition);
		$this->_ability_add(new mygame_game_ability_Health($this, null, null, null));
		$this->_ability_add(new mygame_game_ability_PositionPlan($this, 2));
		$this->_ability_add(new mygame_game_ability_Mobility($this, 1000));
		$this->_ability_add(new mygame_game_ability_Guidance($this));
		$this->_ability_add(new mygame_game_ability_Weapon($this, $oGame->singleton_get(_hx_qtype("mygame.game.misc.weapon.WeaponTypeSoldier"))));
		$this->_ability_add(new mygame_game_ability_LoyaltyShifter($this));
	}}
	public $_oPlatoon;
	public function platoon_get() {
		return $this->_oPlatoon;
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
	function __toString() { return 'mygame.game.entity.SubUnit'; }
}
