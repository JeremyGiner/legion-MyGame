<?php

class mygame_game_process_VictoryCondition implements trigger_ITrigger{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_oGame = $oGame;
		$this->_fVictory = 0;
		$this->_oChallenger = null;
		$this->_mObjectif = new haxe_ds_IntMap();
		$this->_mObjectif->set(0, new HList());
		$this->_mObjectif->set(1, new HList());
		$this->_oGame->onLoop->attach($this);
	}}
	public $_oGame;
	public $_fVictory;
	public $_oChallenger;
	public $_mObjectif;
	public function challenger_get() {
		return $this->_oChallenger;
	}
	public function value_get() {
		return $this->_fVictory;
	}
	public function _objectifCount_get() {}
	public function process() {
		$this->_init();
		$fDelta = 0;
		$iCountMax = 0;
		$iChallengerIdNew = null;
		if(null == $this->_mObjectif) throw new HException('null iterable');
		$__hx__it = $this->_mObjectif->keys();
		while($__hx__it->hasNext()) {
			unset($iPlayerId);
			$iPlayerId = $__hx__it->next();
			$iCount = $this->_mObjectif->get($iPlayerId)->length;
			if($iCount === $iCountMax) {
				$iChallengerIdNew = null;
				break;
			}
			if($iCount > $iCountMax) {
				$iCountMax = $iCount;
				$iChallengerIdNew = $iPlayerId;
			}
			unset($iCount);
		}
		$this->_victory_process($iChallengerIdNew);
		if($this->_fVictory > 1) {
			$this->_oGame->end($this->_oChallenger);
		}
	}
	public function _victory_process($iChallengerIdNew) {
		if($this->_oChallenger === null) {
			$this->_oChallenger = $this->_oGame->player_get($iChallengerIdNew);
			return;
		}
		if($this->_oChallenger->playerId_get() !== $iChallengerIdNew) {
			if($iChallengerIdNew === null) {
				return;
			}
			if($this->_fVictory - 0.001 < 0) {
				$this->_oChallenger = $this->_oGame->player_get($iChallengerIdNew);
				return;
			} else {
				$this->_fVictory -= 0.001;
				return;
			}
		} else {
			$this->_fVictory += 0.001;
			return;
		}
	}
	public function _influence_get() {}
	public function _init() {
		$this->_mObjectif = new haxe_ds_IntMap();
		{
			$_g = 0;
			$_g1 = $this->_oGame->entity_get_all();
			while($_g < $_g1->length) {
				$oEntity = $_g1[$_g];
				++$_g;
				$oLoyaltyShift = $oEntity->ability_get(_hx_qtype("mygame.game.ability.LoyaltyShift"));
				if($oLoyaltyShift !== null) {
					$oUnit = $oEntity;
					$oPlayer = $oUnit->owner_get();
					if($oPlayer !== null) {
						if(!$this->_mObjectif->exists($oPlayer->playerId_get())) {
							$this->_mObjectif->set($oPlayer->playerId_get(), new HList());
						}
						$this->_mObjectif->get($oPlayer->playerId_get())->add($oUnit);
					}
					unset($oUnit,$oPlayer);
				}
				unset($oLoyaltyShift,$oEntity);
			}
		}
	}
	public function trigger($oSource) {
		if($oSource === $this->_oGame->onLoop) {
			$this->process();
		}
		if($oSource === $this->_oGame->onEntityNew) {}
		if($oSource === $this->_oGame->onEntityUpdate) {
			if(Std::is($this->_oGame->onEntityUpdate->event_get(), _hx_qtype("mygame.game.entity.Unit"))) {
				$oLoyaltyShift = $this->_oGame->onEntityUpdate->event_get()->ability_get(_hx_qtype("mygame.game.ability.LoyaltyShift"));
				if($oLoyaltyShift !== null) {
					$oUnit = $oLoyaltyShift->unit_get();
					if(null == $this->_mObjectif) throw new HException('null iterable');
					$__hx__it = $this->_mObjectif->iterator();
					while($__hx__it->hasNext()) {
						unset($lObjectif);
						$lObjectif = $__hx__it->next();
						$lObjectif->remove($oUnit);
					}
					$this->_mObjectif->get($oUnit->owner_get()->playerId_get())->add($oUnit);
				}
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
	function __toString() { return 'mygame.game.process.VictoryCondition'; }
}
