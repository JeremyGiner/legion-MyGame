<?php

class mygame_game_process_CreditIncome implements trigger_ITrigger{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_oGame = $oGame;
		$this->_oGame->onLoop->attach($this);
	}}
	public $_oGame;
	public function _process() {
		if(_hx_mod($this->_oGame->loopId_get(), Math::round(133.33333333333334)) !== 0) {
			return;
		}
		{
			$_g = 0;
			$_g1 = $this->_oGame->player_get_all();
			while($_g < $_g1->length) {
				$oPlayer = $_g1[$_g];
				++$_g;
				$oPlayer->credit_add(10);
				unset($oPlayer);
			}
		}
	}
	public function trigger($oSource) {
		if($oSource === $this->_oGame->onLoop) {
			$this->_process();
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
	function __toString() { return 'mygame.game.process.CreditIncome'; }
}
