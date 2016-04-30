<?php

class mygame_game_process_LoyaltyShiftProcess implements trigger_ITrigger{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_oGame = $oGame;
		$this->_oQueryLoyaltyShift = new mygame_game_query_EntityQuery($this->_oGame, mygame_game_process_LoyaltyShiftProcess_0($this, $oGame));
		$this->_oQueryLoyaltyShifter = new mygame_game_query_EntityQuery($this->_oGame, mygame_game_process_LoyaltyShiftProcess_1($this, $oGame));
		$this->_oGame->onLoop->attach($this);
	}}
	public $_oGame;
	public $_oQueryLoyaltyShift;
	public $_oQueryLoyaltyShifter;
	public function process() {
		if(null == $this->_oQueryLoyaltyShift->data_get(null)) throw new HException('null iterable');
		$__hx__it = $this->_oQueryLoyaltyShift->data_get(null)->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity);
			$oEntity = $__hx__it->next();
			$oLoyaltyShift = $oEntity->ability_get(_hx_qtype("mygame.game.ability.LoyaltyShift"));
			$this->_process($oLoyaltyShift);
			unset($oLoyaltyShift);
		}
	}
	public function _process($oLoyaltyShift) {
		$mCount = $this->_count_get($oLoyaltyShift);
		if(!$mCount->keys()->hasNext()) {
			return;
		}
		if(_hx_equal($oLoyaltyShift->loyalty_get(), 0)) {
			$oChallenger = null;
			$oChallengerSecond = null;
			if(null == $mCount) throw new HException('null iterable');
			$__hx__it = $mCount->keys();
			while($__hx__it->hasNext()) {
				unset($iPlayerId);
				$iPlayerId = $__hx__it->next();
				if($oChallenger === null) {
					$oChallenger = $this->_oGame->player_get($iPlayerId);
				} else {
					if($mCount->get($oChallenger->playerId_get()) < $mCount->get($iPlayerId)) {
						$oChallenger = $this->_oGame->player_get($iPlayerId);
					} else {
						if($oChallengerSecond === null) {
							$oChallengerSecond = $this->_oGame->player_get($iPlayerId);
						} else {
							if($mCount->get($oChallengerSecond->playerId_get()) < $mCount->get($iPlayerId)) {
								$oChallengerSecond = $this->_oGame->player_get($iPlayerId);
							}
						}
					}
				}
			}
			if($oChallenger !== null && ($oChallengerSecond === null || $oChallengerSecond !== null && $mCount->get($oChallenger->playerId_get()) > $mCount->get($oChallengerSecond->playerId_get()))) {
				$oLoyaltyShift->challenger_set($oChallenger);
				if($oLoyaltyShift->challenger_get() !== null) {
					$oLoyaltyShift->loyalty_increase();
				}
			}
		} else {
			$oChallenger1 = null;
			if(null == $mCount) throw new HException('null iterable');
			$__hx__it = $mCount->keys();
			while($__hx__it->hasNext()) {
				unset($oPlayer);
				$oPlayer = $__hx__it->next();
				if($oChallenger1 === null) {
					$oChallenger1 = $this->_oGame->player_get($oPlayer);
				} else {
					if($mCount->get($oChallenger1->playerId_get()) < $mCount->get($oPlayer)) {
						$oChallenger1 = $this->_oGame->player_get($oPlayer);
					}
				}
			}
			if($oChallenger1 === $oLoyaltyShift->challenger_get()) {
				$oLoyaltyShift->loyalty_increase();
			} else {
				$oLoyaltyShift->loyalty_decrease();
			}
		}
	}
	public function _count_get($oLoyaltyShift) {
		$mCount = new haxe_ds_IntMap();
		if(null == $this->_oQueryLoyaltyShifter->data_get(null)) throw new HException('null iterable');
		$__hx__it = $this->_oQueryLoyaltyShifter->data_get(null)->iterator();
		while($__hx__it->hasNext()) {
			unset($oUnit);
			$oUnit = $__hx__it->next();
			$oPlayer = $oUnit->ability_get(_hx_qtype("mygame.game.ability.Loyalty"))->owner_get();
			if($oPlayer === null) {
				continue;
			}
			$fDist = $this->_oGame->singleton_get(_hx_qtype("mygame.game.query.UnitDist"))->data_get((new _hx_array(array($oLoyaltyShift->unit_get(), $oUnit))));
			if($fDist === null) {
				continue;
			}
			if($fDist > $oLoyaltyShift->radius_get()) {
				continue;
			}
			if($mCount->exists($oPlayer->playerId_get())) {
				$mCount->set($oPlayer->playerId_get(), $mCount->get($oPlayer->playerId_get()) + 1);
			} else {
				$mCount->set($oPlayer->playerId_get(), 1);
			}
			unset($oPlayer,$fDist);
		}
		return $mCount;
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
	function __toString() { return 'mygame.game.process.LoyaltyShiftProcess'; }
}
function mygame_game_process_LoyaltyShiftProcess_0(&$__hx__this, &$oGame) {
	{
		$_g = new haxe_ds_StringMap();
		$_g->set("ability", _hx_qtype("mygame.game.ability.LoyaltyShift"));
		return $_g;
	}
}
function mygame_game_process_LoyaltyShiftProcess_1(&$__hx__this, &$oGame) {
	{
		$_g1 = new haxe_ds_StringMap();
		$_g1->set("ability", _hx_qtype("mygame.game.ability.LoyaltyShifter"));
		return $_g1;
	}
}
