<?php

class mygame_game_action_UnitDirectControl implements mygame_game_action_IAction{
	public function __construct($oPlayer, $oDirection) {
		if(!php_Boot::$skip_constructor) {
		$this->_oPlayer = $oPlayer;
		$this->_oDirection = $oDirection;
	}}
	public $_oDirection;
	public $_oPlayer;
	public function direction_get() {
		return $this->_oDirection;
	}
	public function exec($oGame) {
		$oUnit = $oGame->hero_get($this->_oPlayer);
		$oUnit->ability_get(_hx_qtype("mygame.game.ability.Mobility"))->force_set("Direct", $this->_oDirection->x, $this->_oDirection->y, true);
		$oUnit->ability_remove(_hx_qtype("mygame.game.ability.Guidance"));
	}
	public function check($oGame) {
		return true;
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
	function __toString() { return 'mygame.game.action.UnitDirectControl'; }
}
