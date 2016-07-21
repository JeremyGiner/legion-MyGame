<?php

class mygame_game_ability_Loyalty extends mygame_game_ability_EntityAbility {
	public function __construct($oEntity, $oPlayer) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oEntity);
		$this->_oOwner = $oPlayer;
		$this->onUpdate = new trigger_EventDispatcher2();
		$this->onUpdate->attach($this->_oEntity->game_get()->onLoyaltyAnyUpdate);
	}}
	public $_oOwner;
	public $onUpdate;
	public function owner_get() {
		return $this->_oOwner;
	}
	public function owner_set($oPlayer) {
		$this->_oOwner = $oPlayer;
		$this->onUpdate->dispatch($this);
		return $this;
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
	function __toString() { return 'mygame.game.ability.Loyalty'; }
}
