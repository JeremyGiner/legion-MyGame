<?php

class mygame_game_entity_Unit extends legion_entity_Entity {
	public function __construct($oGame, $oOwner, $oPosition) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oGame);
		$this->_oPlayer = $oOwner;
		$this->_ability_add(new mygame_game_ability_Position($this, $oGame->map_get(), $oPosition->x, $oPosition->y));
	}}
	public $_oPlayer;
	public function owner_get() {
		return $this->_oPlayer;
	}
	public function owner_set($oPlayer) {
		$this->onUpdate->dispatch($this);
		$this->_oPlayer = $oPlayer;
	}
	public function mygame_get() {
		return $this->_oGame;
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
	function __toString() { return 'mygame.game.entity.Unit'; }
}
