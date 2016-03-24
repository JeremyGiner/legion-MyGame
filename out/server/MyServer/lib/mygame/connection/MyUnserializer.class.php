<?php

class mygame_connection_MyUnserializer extends haxe_Unserializer {
	public function __construct($s, $oGame) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($s);
		$this->game_set($oGame);
	}}
	public $_oGame;
	public function game_set($oGame) {
		$this->_oGame = $oGame;
	}
	public function unserialize() {
		$_g = null;
		{
			$p = $this->pos++;
			$_g = ord(substr($this->buf,$p,1));
		}
		switch($_g) {
		case 85:{
			$id = $this->unserialize();
			$v = $this->_oGame->entity_get($id);
			if($v === null) {
				throw new HException("No reference for Entity #" . _hx_string_rec($id, "") . " for given game");
			}
			return $v;
		}break;
		default:{
			$this->pos--;
			return parent::unserialize();
		}break;
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
	static function run($s, $oGame) {
		return _hx_deref(new mygame_connection_MyUnserializer($s, $oGame))->unserialize();
	}
	function __toString() { return 'mygame.connection.MyUnserializer'; }
}
