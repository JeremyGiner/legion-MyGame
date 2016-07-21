<?php

class mygame_game_query_UnitDist implements trigger_ITrigger, legion_IQuery{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_mEntityQueue = new haxe_ds_IntMap();
		$this->_oGame = $oGame;
		$this->_mCacheEntity = null;
		$this->_mCacheDist = null;
		$this->onUpdate = new trigger_EventDispatcher2();
		$this->_oGame->onEntityNew->attach($this);
		$this->_oGame->onPositionAnyUpdate->attach($this);
		$this->_oGame->onEntityDispose->attach($this);
		$this->_oGame->onEntityAbilityRemove->attach($this);
		$this->_oGame->onEntityAbilityAdd->attach($this);
	}}
	public $_oGame;
	public $_mCacheEntity;
	public $_mCacheDist;
	public $_mEntityQueue;
	public $onUpdate;
	public function data_get($aUnit) {
		if($aUnit->length !== 2) {
			throw new HException("Invalid parameter : length != 2");
		}
		if($this->_mCacheEntity === null) {
			$this->_cache_update();
		}
		$this->_queue_process();
		$fDistSqed = $this->_cacheValue_get($aUnit[0], $aUnit[1]);
		if($fDistSqed === null) {
			return null;
		} else {
			return Math::sqrt($fDistSqed);
		}
	}
	public function distanceSqed_get($oEntity0, $oEntity1) {
		if($this->_mCacheEntity === null) {
			$this->_cache_update();
		}
		$this->_queue_process();
		return $this->_cacheValue_get($oEntity0, $oEntity1);
	}
	public function entityList_get_byProximity($oEntity0, $fRadius) {
		$l = new HList();
		if($this->_mCacheEntity === null) {
			$this->_cache_update();
		}
		$this->_queue_process();
		$fRadiusSqed = $fRadius * $fRadius;
		if(null == $this->_mCacheEntity) throw new HException('null iterable');
		$__hx__it = $this->_mCacheEntity->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity1);
			$oEntity1 = $__hx__it->next();
			$d = $this->_cacheValue_get($oEntity0, $oEntity1);
			if($d <= $fRadiusSqed) {
				$l->push($oEntity1);
			}
			unset($d);
		}
		return $l;
	}
	public function queue_process() {
		$this->_queue_process();
	}
	public function _queue_process() {
		return;
		$lEntityQueue = utils_MapTool::toList($this->_mEntityQueue);
		if($lEntityQueue->length === 0) {
			return;
		}
		$lEntityAll = utils_MapTool::toList($this->_mCacheEntity);
		$lEntity = $lEntityAll;
		$lEntityNext = new HList();
		$lEntityUpdated = new HList();
		if(null == $lEntityQueue) throw new HException('null iterable');
		$__hx__it = $lEntityQueue->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity0);
			$oEntity0 = $__hx__it->next();
			$lEntityNext = new HList();
			if(null == $lEntity) throw new HException('null iterable');
			$__hx__it2 = $lEntity->iterator();
			while($__hx__it2->hasNext()) {
				unset($oEntity1);
				$oEntity1 = $__hx__it2->next();
				$this->_mCacheDist->set($this->_key_get($oEntity0, $oEntity1), -1);
				$lEntityUpdated->push((new _hx_array(array($oEntity0, $oEntity1))));
				if($oEntity1 !== $oEntity0) {
					$lEntityNext->push($oEntity1);
				}
			}
			$lEntity = $lEntityNext;
		}
		$this->_mEntityQueue = new haxe_ds_IntMap();
		if(null == $lEntityUpdated) throw new HException('null iterable');
		$__hx__it = $lEntityUpdated->iterator();
		while($__hx__it->hasNext()) {
			unset($aEntity);
			$aEntity = $__hx__it->next();
			$this->onUpdate->dispatch($aEntity);
		}
	}
	public function _cacheValue_get($oEntity0, $oEntity1) {
		$sKey = $this->_key_get($oEntity0, $oEntity1);
		$fDistSqed = $this->_mCacheDist->get($sKey);
		if(_hx_equal($fDistSqed, -1)) {
			$fDistSqed = $oEntity0->abilityMap_get()->get("mygame.game.ability.Position")->distanceSqed_get($oEntity1->abilityMap_get()->get("mygame.game.ability.Position"));
			$this->_mCacheDist->set($sKey, $fDistSqed);
		}
		return $fDistSqed;
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
		if($oEntity->abilityMap_get()->get("mygame.game.ability.Position") === null) {
			return false;
		}
		return true;
	}
	public function _cacheValue_create($oEntity0) {
		$this->_mCacheEntity->set($oEntity0->identity_get(), $oEntity0);
		$this->_cacheValue_update($oEntity0);
	}
	public function _cacheValue_remove($oEntity0) {
		$this->_mCacheEntity->remove($oEntity0->identity_get());
		if(null == $this->_mCacheEntity) throw new HException('null iterable');
		$__hx__it = $this->_mCacheEntity->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity1);
			$oEntity1 = $__hx__it->next();
			$this->_mCacheDist->remove($this->_key_get($oEntity0, $oEntity1));
		}
	}
	public function _cacheValue_update($oEntity0) {
		if(null == $this->_mCacheEntity) throw new HException('null iterable');
		$__hx__it = $this->_mCacheEntity->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity1);
			$oEntity1 = $__hx__it->next();
			$this->_mCacheDist->set($this->_key_get($oEntity0, $oEntity1), -1);
			$this->onUpdate->dispatch((new _hx_array(array($oEntity0, $oEntity1))));
		}
	}
	public function _key_get($oEntity0, $oEntity1) {
		if($oEntity0->identity_get() > $oEntity1->identity_get()) {
			return _hx_string_rec($oEntity1->identity_get(), "") . ":" . _hx_string_rec($oEntity0->identity_get(), "");
		}
		return _hx_string_rec($oEntity0->identity_get(), "") . ":" . _hx_string_rec($oEntity1->identity_get(), "");
	}
	public function trigger($oSource) {
		if($this->_mCacheEntity === null) {
			return;
		}
		if($oSource === $this->_oGame->onEntityNew) {
			$oEntity = $this->_oGame->onEntityNew->event_get();
			if($this->_test($oEntity)) {
				$this->_cacheValue_create($oEntity);
			}
			return;
		}
		if($oSource === $this->_oGame->onEntityDispose) {
			$this->_cacheValue_remove($this->_oGame->onEntityDispose->event_get());
			return;
		}
		if($oSource === $this->_oGame->onEntityAbilityAdd) {
			$oEntity1 = $this->_oGame->onEntityAbilityAdd->event_get()->entity;
			if($this->_mCacheEntity->exists($oEntity1->identity_get())) {
				return;
			}
			if($this->_test($oEntity1)) {
				$this->_cacheValue_create($oEntity1);
			}
			return;
		}
		if($oSource === $this->_oGame->onEntityAbilityRemove) {
			$oEntity2 = $this->_oGame->onEntityAbilityRemove->event_get()->entity;
			if(!$this->_test($oEntity2)) {
				$this->_cacheValue_remove($oEntity2);
			}
			return;
		}
		if($oSource === $this->_oGame->onPositionAnyUpdate) {
			$oEntity3 = $this->_oGame->onPositionAnyUpdate->event_get()->unit_get();
			{
				$key = $oEntity3->identity_get();
				$this->_mEntityQueue->set($key, $oEntity3);
			}
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
