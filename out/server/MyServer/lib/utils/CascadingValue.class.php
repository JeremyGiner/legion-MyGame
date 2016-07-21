<?php

class utils_CascadingValue implements trigger_ITrigger{
	public function __construct($aDispatcher) {
		if(!php_Boot::$skip_constructor) {
		$this->_aDispatcher = $aDispatcher;
		$this->_bUpToDate = false;
		{
			$_g = 0;
			$_g1 = $this->_aDispatcher;
			while($_g < $_g1->length) {
				$o = $_g1[$_g];
				++$_g;
				$o->attach($this);
				unset($o);
			}
		}
		$this->onUpdate = new trigger_EventDispatcher2();
	}}
	public $_aDispatcher;
	public $_oValue;
	public $_bUpToDate;
	public $onUpdate;
	public function get() {
		if(!$this->_bUpToDate) {
			$oValueOld = $this->_oValue;
			$this->_update();
			$this->_bUpToDate = true;
		}
		return $this->_oValue;
	}
	public function _update() {
		throw new HException("abstract");
	}
	public function trigger($oSource) {
		$this->_bUpToDate = false;
		$this->onUpdate->dispatch($this);
	}
	public function dispose() {
		$_g = 0;
		$_g1 = $this->_aDispatcher;
		while($_g < $_g1->length) {
			$oDispatcher = $_g1[$_g];
			++$_g;
			$oDispatcher->remove($this);
			unset($oDispatcher);
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
	function __toString() { return 'utils.CascadingValue'; }
}
