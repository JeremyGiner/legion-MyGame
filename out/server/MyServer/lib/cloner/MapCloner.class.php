<?php

class cloner_MapCloner {
	public function __construct($cloner1, $type) {
		if(!php_Boot::$skip_constructor) {
		$this->cloner = $cloner1;
		$this->type = $type;
		$this->noArgs = (new _hx_array(array()));
	}}
	public $cloner;
	public $type;
	public $noArgs;
	public function hclone($inValue) {
		$inMap = $inValue;
		$map = Type::createInstance($this->type, $this->noArgs);
		if(null == $inMap) throw new HException('null iterable');
		$__hx__it = $inMap->keys();
		while($__hx__it->hasNext()) {
			unset($key);
			$key = $__hx__it->next();
			$map->set($key, $this->cloner->_clone($inMap->get($key)));
		}
		return $map;
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
	function __toString() { return 'cloner.MapCloner'; }
}
