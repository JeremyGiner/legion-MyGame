<?php

class mygame_game_process_VolumeEjection implements trigger_ITrigger{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_oGame = $oGame;
		$this->_oGame->onLoop->attach($this);
		$this->_oGame->onEntityNew->attach($this);
		$this->_oGame->onAbilityDispose->attach($this);
		$this->_loVolume = new HList();
	}}
	public $_oGame;
	public $_loVolume;
	public function process() {
		if(null == $this->_oGame->unitList_get()) throw new HException('null iterable');
		$__hx__it = $this->_oGame->unitList_get()->iterator();
		while($__hx__it->hasNext()) {
			unset($oUnit);
			$oUnit = $__hx__it->next();
			$oMobility = $oUnit->ability_get(_hx_qtype("mygame.game.ability.Mobility"));
			if($oMobility === null) {
				continue;
			}
			$oMobility->force_set("volume", 0, 0, false);
			if(null == $this->_loVolume) throw new HException('null iterable');
			$__hx__it2 = $this->_loVolume->iterator();
			while($__hx__it2->hasNext()) {
				unset($oVolume);
				$oVolume = $__hx__it2->next();
				if($oVolume->unit_get() === $oUnit) {
					continue;
				}
				$fVolumeSecondSize = 0.0;
				$oVolumeSecond = $oUnit->ability_get(_hx_qtype("mygame.game.ability.Volume"));
				if($oVolumeSecond !== null) {
					$fVolumeSecondSize = $oVolumeSecond->size_get();
				}
				$oVector = $this->_oGame->positionDistance_get()->delta_get($oMobility->position_get(), $oVolume->position_get());
				if($oVector->length_get() > $oVolume->size_get() + $fVolumeSecondSize) {
					continue;
				}
				$oVector->length_set(($oVolume->size_get() + $fVolumeSecondSize - $oVector->length_get()) * 0.5);
				$oMobility->force_set("volume", $oVector->x, $oVector->y, false);
				unset($oVolumeSecond,$oVector,$fVolumeSecondSize);
			}
			unset($oMobility);
		}
	}
	public function trigger($oSource) {
		if($oSource === $this->_oGame->onLoop) {
			$this->process();
		}
		if($oSource === $this->_oGame->onEntityNew) {
			$oVolume = _hx_deref(($oSource->event_get()))->ability_get(_hx_qtype("mygame.game.ability.Volume"));
			if($oVolume !== null) {
				$this->_loVolume->push($oVolume);
			}
		}
		if($oSource === $this->_oGame->onAbilityDispose && Std::is($oSource->event_get(), _hx_qtype("mygame.game.ability.Volume"))) {
			$oVolume1 = null;
			$oVolume1 = $oSource->event_get();
			$this->_loVolume->remove($oVolume1);
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
	function __toString() { return 'mygame.game.process.VolumeEjection'; }
}
