<?php

class mygame_game_utils_CascadingValiEntity extends utils_CascadingValue {
	public function __construct($oEntity, $oVali, $aDispatcher) {
		if(!php_Boot::$skip_constructor) {
		$this->_oEntity = $oEntity;
		$this->_oVali = $oVali;
		parent::__construct($aDispatcher);
		$this->_oValue = null;
	}}
	public $_oEntity;
	public $_oVali;
	public function entity_get() {
		return $this->_oEntity;
	}
	public function _update() {
		$this->_oValue = $this->_oVali->validate($this->_oEntity);
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
	function __toString() { return 'mygame.game.utils.CascadingValiEntity'; }
}
