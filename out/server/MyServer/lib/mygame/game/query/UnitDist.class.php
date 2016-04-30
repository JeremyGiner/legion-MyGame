<?php

class mygame_game_query_UnitDist implements trigger_ITrigger, legion_IQuery{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_oGame = $oGame;
		$this->_mCacheEntity = null;
		$this->_mCacheDist = null;
		$this->_oGame->onEntityNew->attach($this);
		$this->_oGame->onPositionAnyUpdate->attach($this);
		$this->_oGame->onEntityDispose->attach($this);
	}}
	public $_oGame;
	public $_mCacheEntity;
	public $_mCacheDist;
	public function data_get($aUnit) {
		if($aUnit->length !== 2) {
			throw new HException("Invalid parameter : length != 2");
		}
		if($this->_mCacheEntity === null) {
			$this->_cache_update();
		}
		return $this->_mCacheDist->get($this->_key_get($aUnit[0], $aUnit[1]));
	}
	public function entityList_get_byProximity($oEntity0, $fRadius) {
		$l = new HList();
		if(null == $this->_mCacheEntity) throw new HException('null iterable');
		$__hx__it = $this->_mCacheEntity->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity1);
			$oEntity1 = $__hx__it->next();
			if($this->_mCacheDist->get($this->_key_get($oEntity0, $oEntity1)) <= $fRadius) {
				$l->push($oEntity1);
			}
		}
		return $l;
	}
	public function _cache_update() {
		$this->_mCacheEntity = new haxe_ds_IntMap();
		$this->_mCacheDist = new haxe_ds_StringMap();
		{
			$_g = 0;
			$_g1 = $this->_oGame->entity_get_all();
			while($_g < $_g1->length) {
				$oEntity = $_g1[$_g];
				++$_g;
				if(!$this->_test($oEntity)) {
					continue;
				}
				$this->_cacheValue_create($oEntity);
				unset($oEntity);
			}
		}
	}
	public function _test($oEntity) {
		if($oEntity->ability_get(_hx_qtype("mygame.game.ability.Position")) === null) {
			return false;
		}
		return true;
	}
	public function _cacheValue_create($oEntity0) {
		$this->_cacheValue_update($oEntity0);
		$this->_mCacheEntity->set($oEntity0->identity_get(), $oEntity0);
		$this->_mCacheDist->set($this->_key_get($oEntity0, $oEntity0), 0);
		$oEntity0->ability_get(_hx_qtype("mygame.game.ability.Position"))->onUpdate->attach($this);
	}
	public function _cacheValue_remove($oEntity0) {
		if(null == $this->_mCacheEntity) throw new HException('null iterable');
		$__hx__it = $this->_mCacheEntity->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity1);
			$oEntity1 = $__hx__it->next();
			$this->_mCacheDist->remove($this->_key_get($oEntity0, $oEntity1));
		}
		$this->_mCacheEntity->remove($oEntity0->identity_get());
		$oEntity0->ability_get(_hx_qtype("mygame.game.ability.Position"))->onUpdate->remove($this);
	}
	public function _cacheValue_update($oEntity0) {
		if(null == $this->_mCacheEntity) throw new HException('null iterable');
		$__hx__it = $this->_mCacheEntity->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity1);
			$oEntity1 = $__hx__it->next();
			$this->_mCacheDist->set($this->_key_get($oEntity0, $oEntity1), $oEntity0->ability_get(_hx_qtype("mygame.game.ability.Position"))->distance_get($oEntity1->ability_get(_hx_qtype("mygame.game.ability.Position"))));
		}
	}
	public function _key_get($oEntity0, $oEntity1) {
		if($oEntity0->identity_get() > $oEntity1->identity_get()) {
			return $this->_key_get($oEntity1, $oEntity0);
		}
		return _hx_string_rec($oEntity0->identity_get(), "") . ":" . _hx_string_rec($oEntity1->identity_get(), "");
	}
	public function trigger($oSource) {
		if($this->_mCacheEntity === null) {
			return;
		}
		if($oSource === $this->_oGame->onEntityNew) {
			$oEntity = $oSource->event_get();
			if($this->_test($oEntity)) {
				$this->_cacheValue_create($oEntity);
			}
			return;
		}
		if($oSource === $this->_oGame->onEntityDispose) {
			$oEntity1 = $oSource->event_get();
			$this->_cacheValue_remove($oEntity1);
			return;
		}
		if($oSource === $this->_oGame->onPositionAnyUpdate) {
			$this->_cacheValue_update($this->_oGame->onPositionAnyUpdate->event_get()->unit_get());
			return;
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
	function __toString() { return 'mygame.game.query.UnitDist'; }
}
