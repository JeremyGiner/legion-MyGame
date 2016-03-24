<?php

class mygame_connection_MySerializer extends haxe_Serializer {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->useRelative_set(mygame_connection_MySerializer::$_bUSE_RELATIVE);
	}}
	public $_bUseRelative;
	public function useRelative_set($bUseRelative) {
		$this->_bUseRelative = $bUseRelative;
	}
	public function serialize($v) {
		if($this->_bUseRelative && Std::is($v, _hx_qtype("legion.entity.Entity"))) {
			$this->buf->add("U");
			$this->serialize($v->identity_get());
		} else {
			parent::serialize($v);
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
	static $_bUSE_RELATIVE = false;
	static function run($v) {
		$s = new mygame_connection_MySerializer();
		$s->serialize($v);
		return $s->toString();
	}
	function __toString() { return 'mygame.connection.MySerializer'; }
}
