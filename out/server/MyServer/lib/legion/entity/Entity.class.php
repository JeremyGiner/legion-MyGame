<?php

class legion_entity_Entity {
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_moAbility = new haxe_ds_StringMap();
		$this->_lBehavour = new HList();
		$this->_iIdentity = null;
		$this->_oGame = $oGame;
		$this->onAbilityAdd = new trigger_EventDispatcher2();
		$this->onAbilityRemove = new trigger_EventDispatcher2();
		$this->onDispose = new trigger_EventDispatcher2();
	}}
	public $_iIdentity;
	public $_oGame;
	public $_moAbility;
	public $_lBehavour;
	public $onAbilityAdd;
	public $onAbilityRemove;
	public $onDispose;
	public function dispose_check() {
		return $this->_oGame === null;
	}
	public function identity_get() {
		return $this->_iIdentity;
	}
	public function identity_set($i) {
		$this->_iIdentity = $i;
	}
	public function game_get() {
		return $this->_oGame;
	}
	public function ability_get($oClass) {
		if($this->_moAbility === null) {
			throw new HException("sdqsdqs");
		}
		return $this->_moAbility->get(Type::getClassName($oClass));
	}
	public function abilityMap_get() {
		return $this->_moAbility;
	}
	public function behaviourList_get() {
		return $this->_lBehavour;
	}
	public function behaviour_add($oBeha) {
		$this->_lBehavour->push($oBeha);
	}
	public function ability_add($oAbility) {
		$this->_ability_add($oAbility);
		$this->onAbilityAdd->dispatch(_hx_anonymous(array("ability" => $oAbility, "entity" => $this)));
	}
	public function ability_remove($oClass) {
		$sClassName = Type::getClassName($oClass);
		if(!$this->_moAbility->exists($sClassName)) {
			return;
		}
		$oAbility = $this->_moAbility->get($sClassName);
		$this->_moAbility->remove($sClassName);
		$this->onAbilityRemove->dispatch(_hx_anonymous(array("ability" => $oAbility, "entity" => $this)));
	}
	public function _ability_add($oAbility) {
		$this->_moAbility->set(Type::getClassName(Type::getClass($oAbility)), $oAbility);
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
	function __toString() { return 'legion.entity.Entity'; }
}
