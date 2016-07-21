<?php

class mygame_game_process_MobilityProcess implements trigger_ITrigger{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_oGame = $oGame;
		$this->_loUnit = new HList();
		$this->_oGame->onLoop->attach($this);
		$this->_oGame->onEntityNew->attach($this);
		$this->_oGame->onEntityDispose->attach($this);
	}}
	public $_oGame;
	public $_loUnit;
	public function process() {
		$lUnitDelete = new HList();
		if(null == $this->_loUnit) throw new HException('null iterable');
		$__hx__it = $this->_loUnit->iterator();
		while($__hx__it->hasNext()) {
			unset($oUnit);
			$oUnit = $__hx__it->next();
			$oGuidance = $oUnit->ability_get(_hx_qtype("mygame.game.ability.Guidance"));
			if($oGuidance !== null) {
				$oGuidance->process();
			} else {
				if($oUnit->ability_get(_hx_qtype("mygame.game.ability.Mobility")) === null) {
					$lUnitDelete->push($oUnit);
				}
			}
			unset($oGuidance);
		}
		if(null == $lUnitDelete) throw new HException('null iterable');
		$__hx__it = $lUnitDelete->iterator();
		while($__hx__it->hasNext()) {
			unset($oUnit1);
			$oUnit1 = $__hx__it->next();
			$this->_loUnit->remove($oUnit1);
		}
		if(null == $this->_loUnit) throw new HException('null iterable');
		$__hx__it = $this->_loUnit->iterator();
		while($__hx__it->hasNext()) {
			unset($oUnit2);
			$oUnit2 = $__hx__it->next();
			$oUnit2->ability_get(_hx_qtype("mygame.game.ability.Mobility"))->move();
		}
		$this->_oGame->singleton_get(_hx_qtype("mygame.game.query.EntityDistance"))->queue_process();
	}
	public function trigger($oSource) {
		if($oSource === $this->_oGame->onLoop) {
			$this->process();
			return;
		}
		if($oSource === $this->_oGame->onEntityNew) {
			$oUnit = $oSource->event_get();
			if($oUnit->ability_get(_hx_qtype("mygame.game.ability.Mobility")) !== null) {
				$this->_loUnit->add($oUnit);
			}
		}
		if($oSource === $this->_oGame->onEntityDispose) {
			$this->_loUnit->remove($oSource->event_get());
			return;
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
	function __toString() { return 'mygame.game.process.MobilityProcess'; }
}
