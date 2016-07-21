<?php

class mygame_game_misc_Hit implements mygame_game_misc_IHit{
	public function __construct($iTargetId, $iDamage, $oDamageType) {
		if(!php_Boot::$skip_constructor) {
		$this->_iTargetId = $iTargetId;
		$this->_iDamage = $iDamage;
		$this->_oDamageType = $oDamageType;
	}}
	public $_iDamage;
	public $_iTargetId;
	public $_oDamageType;
	public function damage_get() {
		return $this->_iDamage;
	}
	public function targetId_get() {
		return $this->_iTargetId;
	}
	public function damageType_get() {
		return $this->_oDamageType;
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
	function __toString() { return 'mygame.game.misc.Hit'; }
}
