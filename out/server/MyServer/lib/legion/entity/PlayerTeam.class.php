<?php

class legion_entity_PlayerTeam extends legion_entity_Entity {
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oGame);
		$this->_aPlayer = new _hx_array(array());
	}}
	public $_aPlayer;
	public function player_add($oPlayer) {
		$this->_aPlayer->push($oPlayer);
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
	function __toString() { return 'legion.entity.PlayerTeam'; }
}
