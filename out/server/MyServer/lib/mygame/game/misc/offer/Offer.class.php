<?php

class mygame_game_misc_offer_Offer {
	public function __construct($iCost, $sName) {
		if(!php_Boot::$skip_constructor) {
		$this->_sName = $sName;
		$this->_iCost = 10;
	}}
	public $_sName;
	public $_iCost;
	public function cost_get() {
		return $this->_iCost;
	}
	public function name_get() {
		return $this->_sName;
	}
	public function accept($oBuyer, $oSeller) {
		$oBuyer->credit_add(-$this->_iCost);
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
	function __toString() { return 'mygame.game.misc.offer.Offer'; }
}
