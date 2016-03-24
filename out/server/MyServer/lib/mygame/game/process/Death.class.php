<?php

class mygame_game_process_Death implements trigger_ITrigger{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_oGame = $oGame;
		$this->_lHealth = new HList();
		$this->_oGame->onLoop->attach($this);
		$this->_oGame->onHealthAnyUpdate->attach($this);
	}}
	public $_oGame;
	public $_lHealth;
	public function process() {
		while(!$this->_lHealth->isEmpty()) {
			$oHealth = $this->_lHealth->pop();
			if(_hx_equal($oHealth->get(), 0)) {
				$oHealth->unit_get()->dispose();
			}
			unset($oHealth);
		}
	}
	public function trigger($oSource) {
		if($oSource === $this->_oGame->onLoop) {
			$this->process();
		}
		if($oSource === $this->_oGame->onHealthAnyUpdate) {
			$this->_lHealth->push($this->_oGame->onHealthAnyUpdate->event_get());
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
	function __toString() { return 'mygame.game.process.Death'; }
}
