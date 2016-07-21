<?php

class legion_LocalBehaviourProcess extends legion_BehaviourProcess {
	public function __construct($oGame) { if(!php_Boot::$skip_constructor) {
		parent::__construct($oGame);
	}}
	public function process() {
		if(null == $this->_mOption) throw new HException('null iterable');
		$__hx__it = $this->_mOption->iterator();
		while($__hx__it->hasNext()) {
			unset($oBehviour);
			$oBehviour = $__hx__it->next();
			$oBehviour->process();
		}
	}
	function __toString() { return 'legion.LocalBehaviourProcess'; }
}
