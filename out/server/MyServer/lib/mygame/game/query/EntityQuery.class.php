<?php

class mygame_game_query_EntityQuery implements trigger_ITrigger, legion_IQuery{
	public function __construct($oGame, $oFilter, $aEventDispatcher = null) {
		if(!php_Boot::$skip_constructor) {
		$this->_mEntityQueue = new haxe_ds_IntMap();
		if($aEventDispatcher !== null) {
			$this->_aEventDispatcher = $aEventDispatcher;
		} else {
			$this->_aEventDispatcher = (new _hx_array(array()));
		}
		$this->_oGame = $oGame;
		$this->_mCache = null;
		$this->_oValidator = $oFilter;
		$this->_oGame->onEntityNew->attach($this);
		$this->_oGame->onEntityAbilityAdd->attach($this);
		$this->_oGame->onEntityAbilityRemove->attach($this);
		$this->_oGame->onLoyaltyAnyUpdate->attach($this);
		$this->_oGame->onEntityDispose->attach($this);
		{
			$_g = 0;
			$_g1 = $this->_aEventDispatcher;
			while($_g < $_g1->length) {
				$oEventDispatcher = $_g1[$_g];
				++$_g;
				$oEventDispatcher->attach($this);
				unset($oEventDispatcher);
			}
		}
	}}
	public $_oGame;
	public $_mCache;
	public $_aValidator;
	public $_oValidator;
	public $_aEventDispatcher;
	public $_mEntityQueue;
	public function data_get($o) {
		if($this->_mCache === null) {
			$this->_cache_update();
		}
		$lEntityQueue = utils_MapTool::toList($this->_mEntityQueue);
		if($lEntityQueue->length !== 0) {
			$this->_queue_process($lEntityQueue);
		}
		$this->_mEntityQueue = new haxe_ds_IntMap();
		return $this->_mCache;
	}
	public function _queue_process($lEntityQueue) {
		if(null == $lEntityQueue) throw new HException('null iterable');
		$__hx__it = $lEntityQueue->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity);
			$oEntity = $__hx__it->next();
			if($this->_test($oEntity)) {
				$this->_mCache->set($oEntity->identity_get(), $oEntity);
			} else {
				$this->_mCache->remove($oEntity->identity_get());
			}
		}
	}
	public function _cache_update() {
		$this->_mCache = new haxe_ds_IntMap();
		if(null == $this->_oGame->entity_get_all()) throw new HException('null iterable');
		$__hx__it = $this->_oGame->entity_get_all()->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity);
			$oEntity = $__hx__it->next();
			if(!$this->_test($oEntity)) {
				continue;
			}
			$this->_mCache->set($oEntity->identity_get(), $oEntity);
		}
	}
	public function _test($oEntity) {
		return $this->_oValidator->validate($oEntity);
	}
	public function trigger($oSource) {
		if($this->_mCache === null) {
			return;
		}
		$oEntity = $oSource->event_get();
		if($oSource === $this->_oGame->onEntityAbilityAdd) {
			$oEntity1 = $this->_oGame->onEntityAbilityAdd->event_get()->entity;
			if($this->_test($oEntity1)) {
				$this->_mCache->set($oEntity1->identity_get(), $oEntity1);
			}
			return;
		}
		if($oSource === $this->_oGame->onEntityAbilityRemove) {
			$oEntity2 = $this->_oGame->onEntityAbilityRemove->event_get()->entity;
			if(!$this->_test($oEntity2)) {
				$this->_mCache->remove($oEntity2->identity_get());
			}
			return;
		}
		if($oSource === $this->_oGame->onLoyaltyAnyUpdate) {
			$oEntity3 = $this->_oGame->onLoyaltyAnyUpdate->event_get()->entity_get();
			if($this->_test($oEntity3)) {
				$this->_mCache->set($oEntity3->identity_get(), $oEntity3);
			} else {
				$this->_mCache->remove($oEntity3->identity_get());
			}
			return;
		}
		if($oSource === $this->_oGame->onEntityNew) {
			if($this->_test($oEntity)) {
				$this->_mCache->set($oEntity->identity_get(), $oEntity);
			}
			return;
		}
		if($oSource === $this->_oGame->onEntityDispose) {
			$this->_mCache->remove($oEntity->identity_get());
			return;
		}
		if(Std::is($oSource->event_get(), _hx_qtype("legion.entity.Entity"))) {
			$oEntity4 = $oSource->event_get();
			{
				$key = $oEntity4->identity_get();
				$this->_mEntityQueue->set($key, $oEntity4);
			}
			return;
		}
		if(Std::is($oSource->event_get(), _hx_qtype("mygame.game.ability.UnitAbility"))) {
			$oEntity5 = $oSource->event_get()->unit_get();
			{
				$key1 = $oEntity5->identity_get();
				$this->_mEntityQueue->set($key1, $oEntity5);
			}
			return;
		}
		throw new HException("invalid event type : must be Entity or UnitAbility");
	}
	public function dispose() {
		$this->_oGame->onEntityNew->remove($this);
		$this->_oGame->onEntityAbilityAdd->remove($this);
		$this->_oGame->onEntityAbilityRemove->remove($this);
		$this->_oGame->onLoyaltyAnyUpdate->remove($this);
		$this->_oGame->onPositionAnyUpdate->remove($this);
		$this->_oGame->onEntityDispose->remove($this);
		{
			$_g = 0;
			$_g1 = $this->_aEventDispatcher;
			while($_g < $_g1->length) {
				$oEventDispatcher = $_g1[$_g];
				++$_g;
				$oEventDispatcher->remove($this);
				unset($oEventDispatcher);
			}
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
	function __toString() { return 'mygame.game.query.EntityQuery'; }
}
