<?php

class mygame_game_entity_Player extends legion_entity_Player {
	public function __construct($oGame, $sName = null) {
		if(!php_Boot::$skip_constructor) {
		if($sName === null) {
			$sName = "Annonymous";
		}
		parent::__construct($oGame,$sName);
		$this->_iCredit = 30;
	}}
	public $_iCredit;
	public function credit_get() {
		return $this->_iCredit;
	}
	public function credit_add($iDelta) {
		$this->_iCredit += $iDelta;
		return $this->credit_get();
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
	function __toString() { return 'mygame.game.entity.Player'; }
}
