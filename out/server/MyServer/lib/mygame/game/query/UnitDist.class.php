<?php

class mygame_game_query_UnitDist implements legion_IQuery{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_iLoop = -1;
		$this->_oGame = $oGame;
		$this->_oCache = new haxe_ds_StringMap();
	}}
	public $_oGame;
	public $_oCache;
	public $_iLoop;
	public function data_get($aUnit) {
		if($aUnit->length !== 2) {
			throw new HException("Invalid parameter");
		}
		$oPos0 = _hx_array_get($aUnit, 0)->ability_get(_hx_qtype("mygame.game.ability.Position"));
		$oPos1 = _hx_array_get($aUnit, 1)->ability_get(_hx_qtype("mygame.game.ability.Position"));
		if($oPos0 === null || $oPos1 === null) {
			throw new HException("Missing position ability");
		}
		$this->_cache_update();
		$sKey = _hx_string_rec(_hx_array_get($aUnit, 0)->identity_get(), "") . ";" . _hx_string_rec(_hx_array_get($aUnit, 1)->identity_get(), "");
		if($this->_oCache->exists($sKey)) {
			return $this->_oCache->get($sKey);
		}
		$fResult = space_Vector2i::distance($oPos0, $oPos1);
		$this->_oCache->set($sKey, $fResult);
		return $fResult;
	}
	public function _cache_update() {
		if($this->_iLoop === $this->_oGame->loopId_get()) {
			return;
		}
		$this->_iLoop === $this->_oGame->loopId_get();
		$this->_oCache = new haxe_ds_StringMap();
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
	function __toString() { return 'mygame.game.query.UnitDist'; }
}
