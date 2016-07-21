<?php

class mygame_game_query_EntityDistance implements legion_IQuery{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->onUpdate = new trigger_EventDispatcher2();
		$this->_mKeyToArray = new haxe_ds_StringMap();
		$this->_mEntityQueue = new haxe_ds_IntMap();
		$this->_oGame = $oGame;
		$this->_oQueryEntityPosition = new mygame_game_query_EntityQuery($this->_oGame, new mygame_game_query_ValidatorEntity(mygame_game_query_EntityDistance_0($this, $oGame)), null);
		$this->_mCacheDist = new haxe_ds_StringMap();
	}}
	public $_oGame;
	public $_mCacheDist;
	public $_mEntityQueue;
	public $_oQueryEntityPosition;
	public $_mKeyToArray;
	public $onUpdate;
	public function data_get($aUnit) {
		if($aUnit->length !== 2) {
			throw new HException("Invalid parameter : length != 2");
		}
		return $this->_cacheValue_get($aUnit[0], $aUnit[1]);
	}
	public function distanceSqed_get($oEntity0, $oEntity1) {
		return $this->_cacheValue_get($oEntity0, $oEntity1);
	}
	public function entityList_get_byProximity($oEntity0, $fRadius) {
		$l = new HList();
		$fRadiusSqed = $fRadius * $fRadius;
		if(null == $this->_oQueryEntityPosition->data_get(null)) throw new HException('null iterable');
		$__hx__it = $this->_oQueryEntityPosition->data_get(null)->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity1);
			$oEntity1 = $__hx__it->next();
			$d = $this->_cacheValue_get($oEntity0, $oEntity1)->get();
			if($d <= $fRadiusSqed) {
				$l->push($oEntity1);
			}
			unset($d);
		}
		return $l;
	}
	public function queue_process() {}
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
			$oCasca = new mygame_game_query_CascadingDistSqred($oEntity0, $oEntity1);
			$this->_mCacheDist->set($sKey, $oCasca);
		} else {
			$oCasca = $this->_mCacheDist->get($sKey);
		}
		return $oCasca;
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
	function __toString() { return 'mygame.game.query.EntityDistance'; }
}
function mygame_game_query_EntityDistance_0(&$__hx__this, &$oGame) {
	{
		$_g = new haxe_ds_StringMap();
		$_g->set("ability", _hx_qtype("mygame.game.ability.Position"));
		return $_g;
	}
}
