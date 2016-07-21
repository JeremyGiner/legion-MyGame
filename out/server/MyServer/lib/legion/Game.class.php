<?php

class legion_Game {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->_iIdAutoIncrement = 0;
		$this->_iLoop = 0;
		$this->_mEntity = new haxe_ds_IntMap();
		$this->_mSingleton = new haxe_ds_StringMap();
		$this->_aProcessCallOrder = new _hx_array(array());
		$this->onEntityNew = new trigger_EventDispatcher2();
		$this->onEntityDispose = new trigger_eventdispatcher_EventDispatcherFunel();
		$this->onEntityAbilityAdd = new trigger_eventdispatcher_EventDispatcherFunel();
		$this->onEntityAbilityRemove = new trigger_eventdispatcher_EventDispatcherFunel();
	}}
	public $_iLoop;
	public $_mEntity;
	public $_iIdAutoIncrement;
	public $_mSingleton;
	public $_aProcessCallOrder;
	public $onEntityNew;
	public $onEntityDispose;
	public $onEntityAbilityAdd;
	public $onEntityAbilityRemove;
	public function loopId_get() {
		return $this->_iLoop;
	}
	public function entity_get($i) {
		return $this->_mEntity->get($i);
	}
	public function entity_get_all() {
		return $this->_mEntity;
	}
	public function query_get($oClass) {
		return $this->_mSingleton->get(Type::getClassName($oClass));
	}
	public function singleton_get($oClass) {
		return $this->_mSingleton->get(Type::getClassName($oClass));
	}
	public function action_run($oAction) {
		throw new HException("I am abstract");
		return true;
	}
	public function entity_add($oEntity) {
		$oEntity->identity_set($this->_iIdAutoIncrement);
		$this->_mEntity->set($this->_iIdAutoIncrement, $oEntity);
		$this->_iIdAutoIncrement++;
		$this->onEntityNew->dispatch($oEntity);
		$oEntity->onAbilityAdd->attach($this->onEntityAbilityAdd);
		$oEntity->onAbilityRemove->attach($this->onEntityAbilityRemove);
		$oEntity->onDispose->attach($this->onEntityDispose);
	}
	public function entity_remove($oEntity) {
		$this->_mEntity->remove($oEntity->identity_get());
		$oEntity->onDispose->dispatch($oEntity);
		utils_Disposer::dispose($oEntity);
	}
	public function process() {
		$this->_iLoop++;
		{
			$_g = 0;
			$_g1 = $this->_aProcessCallOrder;
			while($_g < $_g1->length) {
				$oProcess = $_g1[$_g];
				++$_g;
				$oProcess->process();
				unset($oProcess);
			}
		}
	}
	public function _singleton_add($o) {
		$this->_mSingleton->set(Type::getClassName(Type::getClass($o)), $o);
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
	function __toString() { return 'legion.Game'; }
}
