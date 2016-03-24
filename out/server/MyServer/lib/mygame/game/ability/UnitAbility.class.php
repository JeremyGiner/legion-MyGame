<?php

class mygame_game_ability_UnitAbility implements legion_ability_IAbility{
	public function __construct($oUnit) {
		if(!php_Boot::$skip_constructor) {
		$this->_oUnit = $oUnit;
		$this->onDispose = new trigger_eventdispatcher_EventDispatcher();
	}}
	public $_oUnit;
	public $onDispose;
	public function unit_get() {
		return $this->_oUnit;
	}
	public function mainClassName_get() {
		return Type::getClassName(Type::getClass($this));
	}
	public function dispose() {
		$this->onDispose->dispatch($this);
		$this->_oUnit->game_get()->onAbilityDispose->dispatch($this);
		utils_Disposer::dispose($this);
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
	function __toString() { return 'mygame.game.ability.UnitAbility'; }
}
