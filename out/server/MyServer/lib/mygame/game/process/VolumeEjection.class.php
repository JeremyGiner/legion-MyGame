<?php

class mygame_game_process_VolumeEjection implements trigger_ITrigger{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_oGame = $oGame;
		$this->_oQueryVolume = new mygame_game_query_EntityQuery($this->_oGame, new mygame_game_query_ValidatorEntity(mygame_game_process_VolumeEjection_0($this, $oGame)), null);
		$this->_oQueryMobility = new mygame_game_query_EntityQuery($this->_oGame, new mygame_game_query_ValidatorEntity(mygame_game_process_VolumeEjection_1($this, $oGame)), null);
		$this->_oGame->onLoop->attach($this);
	}}
	public $_oGame;
	public $_oQueryVolume;
	public $_oQueryMobility;
	public function process() {
		if(null == $this->_oQueryMobility->data_get(null)) throw new HException('null iterable');
		$__hx__it = $this->_oQueryMobility->data_get(null)->iterator();
		while($__hx__it->hasNext()) {
			unset($oUnit);
			$oUnit = $__hx__it->next();
			$oMobility = $oUnit->ability_get(_hx_qtype("mygame.game.ability.Mobility"));
			if($oMobility === null) {
				continue;
			}
			if($oUnit->ability_get(_hx_qtype("mygame.game.ability.PositionPlan")) === null) {
				continue;
			}
			$oMobility->force_set("volume", 0, 0, false);
			$oForce = $oMobility->force_get("volume");
			if(null == $this->_oQueryVolume->data_get(null)) throw new HException('null iterable');
			$__hx__it2 = $this->_oQueryVolume->data_get(null)->iterator();
			while($__hx__it2->hasNext()) {
				unset($oEntitySource);
				$oEntitySource = $__hx__it2->next();
				if($oEntitySource === $oUnit) {
					continue;
				}
				$oVolume = $oEntitySource->ability_get(_hx_qtype("mygame.game.ability.Volume"));
				$oVolumeTarget = $oUnit->ability_get(_hx_qtype("mygame.game.ability.Volume"));
				$fVolumeTargetSize = null;
				if($oVolumeTarget !== null) {
					$fVolumeTargetSize = $oVolumeTarget->size_get();
				} else {
					$fVolumeTargetSize = 0.0;
				}
				$oVector = $this->_oGame->positionDistance_get()->delta_get($oMobility->position_get(), $oVolume->position_get());
				if($oVector->length_get() > $oVolume->size_get() + $fVolumeTargetSize) {
					continue;
				}
				$oVector->length_set(($oVolume->size_get() + $fVolumeTargetSize - $oVector->length_get()) / 2);
				$oForce->oVector->vector_add($oVector);
				unset($oVolumeTarget,$oVolume,$oVector,$fVolumeTargetSize);
			}
			unset($oMobility,$oForce);
		}
	}
	public function trigger($oSource) {
		if($oSource === $this->_oGame->onLoop) {
			$this->process();
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
function mygame_game_process_VolumeEjection_0(&$__hx__this, &$oGame) {
	{
		$_g = new haxe_ds_StringMap();
		$_g->set("ability", _hx_qtype("mygame.game.ability.Volume"));
		return $_g;
	}
}
function mygame_game_process_VolumeEjection_1(&$__hx__this, &$oGame) {
	{
		$_g1 = new haxe_ds_StringMap();
		$_g1->set("ability", _hx_qtype("mygame.game.ability.Mobility"));
		return $_g1;
	}
}
