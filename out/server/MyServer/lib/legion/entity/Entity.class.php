<?php

class legion_entity_Entity {
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_iIdentity = null;
		$this->_oGame = $oGame;
		$this->_moAbility = new haxe_ds_StringMap();
		$this->onAbilityAdd = new trigger_EventDispatcher2();
		$this->onAbilityRemove = new trigger_EventDispatcher2();
		$this->onDispose = new trigger_EventDispatcher2();
	}}
	public $_iIdentity;
	public $_oGame;
	public $_moAbility;
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
	public function key_get() {
		return $this->_iIdentity;
	}
	public function game_get() {
		return $this->_oGame;
	}
	public function ability_get($oClass) {
		return $this->_moAbility->get(Type::getClassName($oClass));
	}
	public function abilityMap_get() {
		return $this->_moAbility;
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
		$this->_moAbility->remove($sClassName);
		$this->onAbilityRemove->dispatch(_hx_anonymous(array("ability" => $this->_moAbility->get($sClassName), "entity" => $this)));
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
	static function get_byKey($oGame, $iKey) {
		{
			$_g = 0;
			$_g1 = $oGame->entity_get_all();
			while($_g < $_g1->length) {
				$oEntity = $_g1[$_g];
				++$_g;
				if($oEntity->key_get() === $iKey) {
					return $oEntity;
				}
				unset($oEntity);
			}
		}
		return null;
	}
	function __toString() { return 'legion.entity.Entity'; }
}
