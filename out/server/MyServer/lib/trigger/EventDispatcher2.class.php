<?php

class trigger_EventDispatcher2 implements trigger_IEventDispatcher{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->_lTrigger = new HList();
	}}
	public $_lTrigger;
	public $_oEventCurrent;
	public function attach($oITrigger) {
		if($oITrigger === null) {
			throw new HException("[ERROR]:trigger is null");
		}
		$this->_lTrigger->push($oITrigger);
	}
	public function remove($oITrigger) {
		$this->_lTrigger->remove($oITrigger);
	}
	public function event_get() {
		return $this->_oEventCurrent;
	}
	public function triggerListLenght_get() {
		return $this->_lTrigger->length;
	}
	public function dispatch($oEvent = null) {
		$this->_oEventCurrent = $oEvent;
		if(null == $this->_lTrigger) throw new HException('null iterable');
		$__hx__it = $this->_lTrigger->iterator();
		while($__hx__it->hasNext()) {
			unset($oTrigger);
			$oTrigger = $__hx__it->next();
			$oTrigger->trigger($this);
		}
		return $this;
	}
	public function source_check($oSource) {
		if($oSource === $this) {
			return true;
		}
		return false;
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
	function __toString() { return 'trigger.EventDispatcher2'; }
}
