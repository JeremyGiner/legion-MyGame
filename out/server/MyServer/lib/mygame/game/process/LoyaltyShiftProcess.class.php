<?php

class mygame_game_process_LoyaltyShiftProcess implements trigger_ITrigger{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_oGame = $oGame;
		$this->_lAbility = new HList();
		$this->_oGame->onLoop->attach($this);
		$this->_oGame->onEntityNew->attach($this);
		$this->_oGame->onEntityDispose->attach($this);
	}}
	public $_oGame;
	public $_lAbility;
	public function process() {
		if(null == $this->_lAbility) throw new HException('null iterable');
		$__hx__it = $this->_lAbility->iterator();
		while($__hx__it->hasNext()) {
			unset($oAbility);
			$oAbility = $__hx__it->next();
			$oAbility->process();
		}
	}
	public function trigger($oSource) {
		if($oSource === $this->_oGame->onLoop) {
			$this->process();
		}
		if($oSource === $this->_oGame->onEntityNew) {
			$oAbility = $this->_oGame->onEntityNew->event_get()->ability_get(_hx_qtype("mygame.game.ability.LoyaltyShift"));
			if($oAbility !== null) {
				$this->_lAbility->push($oAbility);
			}
		}
		if($oSource === $this->_oGame->onEntityDispose) {
			$oAbility1 = $this->_oGame->onEntityNew->event_get()->ability_get(_hx_qtype("mygame.game.ability.LoyaltyShift"));
			if($oAbility1 !== null) {
				$this->_lAbility->remove($oAbility1);
			}
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
	function __toString() { return 'mygame.game.process.LoyaltyShiftProcess'; }
}
