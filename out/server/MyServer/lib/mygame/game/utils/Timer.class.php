<?php

class mygame_game_utils_Timer {
	public function __construct($oGame, $iFrequency, $bLoop = null) {
		if(!php_Boot::$skip_constructor) {
		if($bLoop === null) {
			$bLoop = false;
		}
		$this->_oGame = $oGame;
		$this->set($iFrequency, $bLoop);
	}}
	public $_oGame;
	public $_iStart;
	public $_iFrequency;
	public $_iExpired;
	public $_bLoop;
	public function reset() {
		$this->_iStart = $this->timeCurrent_get();
		$this->_iExpired = $this->_iStart + $this->_iFrequency;
	}
	public function set($iFrequency, $bLoop = null) {
		if($bLoop === null) {
			$bLoop = false;
		}
		$this->_iFrequency = $iFrequency;
		$this->reset();
	}
	public function expired_check() {
		return $this->_iExpired < $this->timeCurrent_get();
	}
	public function timeCurrent_get() {
		return $this->_oGame->loopId_get();
	}
	public function timeRemain_get() {
		return $this->timeCurrent_get() - $this->_iExpired;
	}
	public function expire_get() {
		return $this->_iExpired;
	}
	public function expirePercent_get() {
		return ($this->timeCurrent_get() - $this->_iStart) / ($this->_iExpired - $this->_iStart);
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
	function __toString() { return 'mygame.game.utils.Timer'; }
}
