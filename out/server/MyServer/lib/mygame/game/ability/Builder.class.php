<?php

class mygame_game_ability_Builder extends mygame_game_ability_UnitAbility {
	public function __construct($oUnit) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oUnit);
		$this->_oProduct = new _hx_array(array());
	}}
	public $_oProduct;
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
	function __toString() { return 'mygame.game.ability.Builder'; }
}
