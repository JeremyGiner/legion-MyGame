<?php

class legion_BehaviourProcess implements legion_IProcessBehaviour, trigger_ITrigger{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_oGame = $oGame;
		$this->_mOption = new haxe_ds_IntMap();
		$this->_oGame->onEntityDispose->attach($this);
	}}
	public $_oGame;
	public $_mOption;
	public function hasEntity($oEntity) {
		return $this->_mOption->exists($oEntity->identity_get());
	}
	public function option_get($oEntity) {
		return $this->_mOption->get($oEntity->identity_get());
	}
	public function add($oEntity, $oOption) {
		$this->_mOption->set($oEntity->identity_get(), $oOption);
		$oEntity->behaviour_add($this);
	}
	public function remove($oEntity) {
		$this->_mOption->remove($oEntity->identity_get());
	}
	public function process() {
		throw new HException("override me");
	}
	public function trigger($oSource) {
		if($oSource === $this->_oGame->onEntityDispose) {
			$this->remove($this->_oGame->onEntityDispose->event_get());
			return;
		}
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
	function __toString() { return 'legion.BehaviourProcess'; }
}
