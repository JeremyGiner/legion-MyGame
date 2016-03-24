<?php

class mygame_game_ability_LoyaltyShift extends mygame_game_ability_UnitAbility {
	public function __construct($oUnit) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oUnit);
		$this->_fLoyalty = 1;
		$this->_oChallenger = $this->_oUnit->owner_get();
		if($this->_oChallenger === null) {
			$this->_fLoyalty = 0;
		}
	}}
	public $_fLoyalty;
	public $_oChallenger;
	public function area_get() {
		mygame_game_ability_LoyaltyShift::$_oArea->position_get()->copy($this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Position")));
		return mygame_game_ability_LoyaltyShift::$_oArea;
	}
	public function loyalty_get() {
		return $this->_fLoyalty;
	}
	public function challenger_get() {
		return $this->_oChallenger;
	}
	public function test() {
		$mCount = new haxe_ds_IntMap();
		$oGame = $this->_oUnit->game_get();
		if(null == $oGame->unitList_get()) throw new HException('null iterable');
		$__hx__it = $oGame->unitList_get()->iterator();
		while($__hx__it->hasNext()) {
			unset($oUnit);
			$oUnit = $__hx__it->next();
			if($this->_oUnit === $oUnit) {
				continue;
			}
			if($oUnit->ability_get(_hx_qtype("mygame.game.ability.LoyaltyShifter")) === null) {
				continue;
			}
			$oPlayer = $oUnit->owner_get();
			if($oPlayer !== null) {
				if($this->unit_check($oUnit)) {
					if($mCount->exists($oPlayer->playerId_get())) {
						$mCount->set($oPlayer->playerId_get(), $mCount->get($oPlayer->playerId_get()) + 1);
					} else {
						$mCount->set($oPlayer->playerId_get(), 1);
					}
				}
			}
			unset($oPlayer);
		}
		return $mCount;
	}
	public function unit_check($oUnit) {
		$oPosition = $oUnit->ability_get(_hx_qtype("mygame.game.ability.Position"));
		if($oPosition === null) {
			return false;
		}
		if(!collider_CollisionCheckerPostInt::check($this->area_get(), $oPosition)) {
			return false;
		}
		return true;
	}
	public function process() {
		$oGame = $this->_oUnit->mygame_get();
		if(_hx_equal($this->_fLoyalty, 0)) {
			$mCount = $this->test();
			if(!$mCount->keys()->hasNext()) {
				return;
			}
			$oChallenger = null;
			$oChallengerSecond = null;
			if(null == $mCount) throw new HException('null iterable');
			$__hx__it = $mCount->keys();
			while($__hx__it->hasNext()) {
				unset($iPlayerId);
				$iPlayerId = $__hx__it->next();
				if($oChallenger === null) {
					$oChallenger = $oGame->player_get($iPlayerId);
				} else {
					if($mCount->get($oChallenger->playerId_get()) < $mCount->get($iPlayerId)) {
						$oChallenger = $oGame->player_get($iPlayerId);
					} else {
						if($oChallengerSecond === null) {
							$oChallengerSecond = $oGame->player_get($iPlayerId);
						} else {
							if($mCount->get($oChallengerSecond->playerId_get()) < $mCount->get($iPlayerId)) {
								$oChallengerSecond = $oGame->player_get($iPlayerId);
							}
						}
					}
				}
			}
			if($oChallenger !== null && ($oChallengerSecond === null || $oChallengerSecond !== null && $mCount->get($oChallenger->playerId_get()) > $mCount->get($oChallengerSecond->playerId_get()))) {
				$this->_oChallenger = $oChallenger;
				if($this->_oChallenger !== null) {
					$this->loyalty_increase();
				}
			}
		} else {
			$mCount1 = $this->test();
			if(!$mCount1->keys()->hasNext()) {
				return;
			}
			$oChallenger1 = null;
			if(null == $mCount1) throw new HException('null iterable');
			$__hx__it = $mCount1->keys();
			while($__hx__it->hasNext()) {
				unset($oPlayer);
				$oPlayer = $__hx__it->next();
				if($oChallenger1 === null) {
					$oChallenger1 = $oGame->player_get($oPlayer);
				} else {
					if($mCount1->get($oChallenger1->playerId_get()) < $mCount1->get($oPlayer)) {
						$oChallenger1 = $oGame->player_get($oPlayer);
					}
				}
			}
			if($oChallenger1 === $this->_oChallenger) {
				$this->loyalty_increase();
			} else {
				$this->loyalty_decrease();
			}
		}
	}
	public function loyalty_increase() {
		$this->_fLoyalty += mygame_game_ability_LoyaltyShift::$_fStep;
		if($this->_fLoyalty >= 0.5) {
			$this->_oUnit->owner_set($this->_oChallenger);
		}
		$this->_fLoyalty = Math::min($this->_fLoyalty, 1);
	}
	public function loyalty_decrease() {
		$this->_fLoyalty -= mygame_game_ability_LoyaltyShift::$_fStep;
		if($this->_fLoyalty < 0.5) {
			$this->_oUnit->owner_set(null);
		}
		$this->_fLoyalty = Math::max($this->_fLoyalty, 0);
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
	static $_fStep = 0.01;
	static $_oArea;
	static $RANGE = 10000;
	function __toString() { return 'mygame.game.ability.LoyaltyShift'; }
}
mygame_game_ability_LoyaltyShift::$_oArea = new space_Circlei(new space_Vector2i(null, null), 10000);
