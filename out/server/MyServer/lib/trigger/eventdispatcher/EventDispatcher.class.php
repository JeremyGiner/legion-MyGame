<?php

class trigger_eventdispatcher_EventDispatcher implements trigger_IEventDispatcher{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->_aoTrigger = new _hx_array(array());
	}}
	public $_aoTrigger;
	public $_oEventCurrent;
	public function attach($oITrigger) {
		$this->_aoTrigger->push($oITrigger);
	}
	public function remove($oITrigger) {
		$this->_aoTrigger->remove($oITrigger);
	}
	public function event_get() {
		return $this->_oEventCurrent;
	}
	public function dispatch($oEvent = null) {
		$this->_oEventCurrent = $oEvent;
		{
			$_g = 0;
			$_g1 = $this->_aoTrigger;
			while($_g < $_g1->length) {
				$oTrigger = $_g1[$_g];
				++$_g;
				$oTrigger->trigger($this);
				unset($oTrigger);
			}
		}
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
	function __toString() { return 'trigger.eventdispatcher.EventDispatcher'; }
}
