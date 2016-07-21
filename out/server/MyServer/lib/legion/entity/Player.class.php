<?php

class legion_entity_Player extends legion_entity_Entity {
	public function __construct($oGame, $sName = null) {
		if(!php_Boot::$skip_constructor) {
		if($sName === null) {
			$sName = "Annonymous";
		}
		parent::__construct($oGame);
		$this->_sName = $sName;
		$this->_oPlayerTeam = new legion_entity_PlayerTeam($oGame);
	}}
	public $_iPlayerId;
	public $_sName;
	public $_oPlayerTeam;
	public function name_get() {
		return $this->_sName;
	}
	public function playerId_get() {
		return $this->_iPlayerId;
	}
	public function playerId_set($iPlayerId) {
		$this->_iPlayerId = $iPlayerId;
	}
	public function alliance_get($oPlayer) {
		if($this === $oPlayer) {
			return legion_entity_ALLIANCE::$ally;
		}
		return legion_entity_ALLIANCE::$ennemy;
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
	function __toString() { return 'legion.entity.Player'; }
}
