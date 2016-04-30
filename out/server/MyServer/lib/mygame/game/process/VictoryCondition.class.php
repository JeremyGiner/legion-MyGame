<?php

class mygame_game_process_VictoryCondition implements trigger_ITrigger{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_oGame = $oGame;
		$this->_fVictory = 0;
		$this->_oChallenger = null;
		$this->_mQueryCity = new haxe_ds_IntMap();
		{
			$_g = 0;
			$_g1 = $this->_oGame->player_get_all();
			while($_g < $_g1->length) {
				$oPlayer = $_g1[$_g];
				++$_g;
				$this->_mQueryCity->set($oPlayer->playerId_get(), new mygame_game_query_EntityQuery($this->_oGame, mygame_game_process_VictoryCondition_0($this, $_g, $_g1, $oGame, $oPlayer)));
				unset($oPlayer);
			}
		}
		$this->_oGame->onLoop->attach($this);
	}}
	public $_oGame;
	public $_fVictory;
	public $_oChallenger;
	public $_mObjectif;
	public $_mQueryCity;
	public function challenger_get() {
		return $this->_oChallenger;
	}
	public function value_get() {
		return $this->_fVictory;
	}
	public function process() {
		$this->_victory_process($this->_playerIdTop_get());
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
	public function _playerIdTop_get() {
		$iCountTop = 0;
		$iPlayerIdTop = null;
		{
			$_g = 0;
			$_g1 = $this->_oGame->player_get_all();
			while($_g < $_g1->length) {
				$oPlayer = $_g1[$_g];
				++$_g;
				$iPlayerId = $oPlayer->identity_get();
				$iCount = utils_MapTool::getLength($this->_mQueryCity->get($iPlayerId)->data_get(null));
				if($iCount === $iCountTop) {
					$iPlayerIdTop = null;
				}
				if($iCount > $iCountTop) {
					$iCountTop = $iCount;
					$iPlayerIdTop = $iPlayerId;
				}
				unset($oPlayer,$iPlayerId,$iCount);
			}
		}
		return $iPlayerIdTop;
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
	function __toString() { return 'mygame.game.process.VictoryCondition'; }
}
function mygame_game_process_VictoryCondition_0(&$__hx__this, &$_g, &$_g1, &$oGame, &$oPlayer) {
	{
		$_g2 = new haxe_ds_StringMap();
		$_g2->set("ability", _hx_qtype("mygame.game.ability.LoyaltyShift"));
		{
			$value = $oPlayer->playerId_get();
			$_g2->set("player", $value);
		}
		return $_g2;
	}
}
