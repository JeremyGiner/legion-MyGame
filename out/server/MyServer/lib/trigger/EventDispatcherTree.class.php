<?php

class trigger_EventDispatcherTree extends trigger_EventDispatcher2 {
	public function __construct($oParent) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->_oParent = $oParent;
	}}
	public $_oParent;
	public function dispatch($oEvent = null) {
		parent::dispatch($oEvent);
		if($this->_oParent !== null) {
			$this->_oParent->dispatch($oEvent);
		}
		return $this;
	}
	public function source_check($oSource) {
		if($oSource === $this) {
			return true;
		}
		return $this->_oParent->source_check($oSource);
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
	function __toString() { return 'trigger.EventDispatcherTree'; }
}
