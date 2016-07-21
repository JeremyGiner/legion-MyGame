<?php

class mygame_game_query_EntityDistanceTile implements legion_IQuery{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_mEntityKey = new haxe_ds_IntMap();
		$this->_mKeyToArray = new haxe_ds_StringMap();
		$this->_oGame = $oGame;
		$this->_mCacheDist = null;
		$this->_mCacheDist = new haxe_ds_StringMap();
	}}
	public $_oGame;
	public $_mCacheDist;
	public $_mEntityKey;
	public $_mKeyToArray;
	public function data_get($aUnit) {
		if($aUnit->length !== 2) {
			throw new HException("Invalid parameter : length != 2");
		}
		return $this->_cacheValue_get($aUnit[0], $aUnit[1]);
	}
	public function _key_to_array($sKey) {
		return $this->_mKeyToArray->get($sKey);
	}
	public function _clean_up() {
		if(null == $this->_mCacheDist) throw new HException('null iterable');
		$__hx__it = $this->_mCacheDist->keys();
		while($__hx__it->hasNext()) {
			unset($s);
			$s = $__hx__it->next();
			$o = $this->_mCacheDist->get($s);
			if($o->onUpdate->triggerListLenght_get() !== 0) {
				continue;
			}
			$o->dispose();
			$this->_mCacheDist->remove($s);
			unset($o);
		}
	}
	public function _cacheValue_get($oEntity0, $oEntity1) {
		$sKey = $this->_key_get($oEntity0, $oEntity1);
		$oCasca = null;
		if(!$this->_mCacheDist->exists($sKey)) {
			$oCasca = new mygame_game_query_CascadingDistTile($oEntity0, $oEntity1);
			$this->_mCacheDist->set($sKey, $oCasca);
		} else {
			$oCasca = $this->_mCacheDist->get($sKey);
		}
		return $oCasca;
	}
	public function _value_get($oEntity0, $oEntity1) {
		$oPos0 = $oEntity0->abilityMap_get()->get("mygame.game.ability.Position");
		$oPos1 = $oEntity1->abilityMap_get()->get("mygame.game.ability.Position");
		$dx = utils_IntTool::abs($oPos0->tile_get()->x_get() - $oPos1->tile_get()->x_get());
		$dy = utils_IntTool::abs($oPos0->tile_get()->y_get() - $oPos1->tile_get()->y_get());
		return utils_IntTool::max($dx, $dy);
	}
	public function _key_get($oEntity0, $oEntity1) {
		$sKey = null;
		if($oEntity0->identity_get() > $oEntity1->identity_get()) {
			$sKey = _hx_string_rec($oEntity1->identity_get(), "") . ":" . _hx_string_rec($oEntity0->identity_get(), "");
		} else {
			$sKey = _hx_string_rec($oEntity0->identity_get(), "") . ":" . _hx_string_rec($oEntity1->identity_get(), "");
		}
		$this->_mKeyToArray->set($sKey, (new _hx_array(array($oEntity0, $oEntity1))));
		return $sKey;
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
	function __toString() { return 'mygame.game.query.EntityDistanceTile'; }
}
