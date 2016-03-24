<?php

class legion_Game {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->_iIdAutoIncrement = 0;
		$this->_aoEntity = new _hx_array(array());
		$this->_mSingleton = new haxe_ds_StringMap();
		$this->onEntityNew = new trigger_EventDispatcher2();
		$this->onEntityUpdate = new trigger_EventDispatcher2();
		$this->onEntityDispose = new trigger_EventDispatcher2();
		$this->onAbilityDispose = new trigger_EventDispatcher2();
	}}
	public $_aoEntity;
	public $_iIdAutoIncrement;
	public $_mSingleton;
	public $onEntityNew;
	public $onEntityUpdate;
	public $onEntityDispose;
	public $onAbilityDispose;
	public function entity_get($i) {
		{
			$_g = 0;
			$_g1 = $this->_aoEntity;
			while($_g < $_g1->length) {
				$oEntity = $_g1[$_g];
				++$_g;
				if($oEntity->identity_get() === $i) {
					return $oEntity;
				}
				unset($oEntity);
			}
		}
		return null;
	}
	public function entity_get_all() {
		return $this->_aoEntity;
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
		$this->_aoEntity->push($oEntity);
		$this->_iIdAutoIncrement++;
		$this->onEntityNew->dispatch($oEntity);
	}
	public function entity_remove($oEntity) {
		$this->_aoEntity->remove($oEntity);
		$this->onEntityDispose->dispatch($oEntity);
	}
	public function _start() {
		legion_Game::$onAnyStart->dispatch($this);
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
	static $onAnyStart;
	function __toString() { return 'legion.Game'; }
}
legion_Game::$onAnyStart = new trigger_eventdispatcher_EventDispatcher();
