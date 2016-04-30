<?php

class mygame_game_query_EntityQuery implements trigger_ITrigger, legion_IQuery{
	public function __construct($oGame, $oFilter) {
		if(!php_Boot::$skip_constructor) {
		$this->_oGame = $oGame;
		$this->_oCache = null;
		$this->_oFilter = $oFilter;
		$this->_oGame->onEntityNew->attach($this);
		$this->_oGame->onEntityAbilityAdd->attach($this);
		$this->_oGame->onEntityAbilityRemove->attach($this);
		$this->_oGame->onLoyaltyAnyUpdate->attach($this);
		$this->_oGame->onEntityDispose->attach($this);
	}}
	public $_oGame;
	public $_oCache;
	public $_oFilter;
	public function data_get($o) {
		if($this->_oCache === null) {
			$this->_cache_update();
		}
		return $this->_oCache;
	}
	public function _cache_update() {
		$this->_oCache = new haxe_ds_IntMap();
		{
			$_g = 0;
			$_g1 = $this->_oGame->entity_get_all();
			while($_g < $_g1->length) {
				$oEntity = $_g1[$_g];
				++$_g;
				if(!$this->_test($oEntity)) {
					continue;
				}
				$this->_oCache->set($oEntity->identity_get(), $oEntity);
				unset($oEntity);
			}
		}
	}
	public function _test($oEntity) {
		if(null == $this->_oFilter) throw new HException('null iterable');
		$__hx__it = $this->_oFilter->keys();
		while($__hx__it->hasNext()) {
			unset($sKey);
			$sKey = $__hx__it->next();
			switch($sKey) {
			case "class":{
				$_oType = $this->_oFilter->get("class");
				if(!Std::is($oEntity, $_oType)) {
					return false;
				}
			}break;
			case "ability":{
				$_oType1 = $this->_oFilter->get("ability");
				if($oEntity->ability_get($_oType1) === null) {
					return false;
				}
			}break;
			case "player":{
				$oLoyalty = $oEntity->ability_get(_hx_qtype("mygame.game.ability.Loyalty"));
				if($oLoyalty === null || $oLoyalty->owner_get() === null || !_hx_equal($oLoyalty->owner_get()->playerId_get(), $this->_oFilter->get("player"))) {
					return false;
				}
			}break;
			default:{
				throw new HException("unknown filter key \"" . _hx_string_or_null($sKey) . "\"");
			}break;
			}
		}
		return true;
	}
	public function trigger($oSource) {
		if($this->_oCache === null) {
			return;
		}
		$oEntity = $oSource->event_get();
		if($oSource === $this->_oGame->onEntityAbilityAdd) {
			$oEntity1 = $this->_oGame->onEntityAbilityAdd->event_get()->entity;
			if($this->_test($oEntity1)) {
				$this->_oCache->set($oEntity1->identity_get(), $oEntity1);
			}
			return;
		}
		if($oSource === $this->_oGame->onEntityAbilityRemove) {
			$oEntity2 = $this->_oGame->onEntityAbilityAdd->event_get()->entity;
			if(!$this->_test($oEntity2)) {
				$this->_oCache->remove($oEntity2->identity_get());
			}
			return;
		}
		if($oSource === $this->_oGame->onLoyaltyAnyUpdate) {
			$oEntity3 = $this->_oGame->onLoyaltyAnyUpdate->event_get()->unit_get();
			if($this->_test($oEntity3)) {
				$this->_oCache->set($oEntity3->identity_get(), $oEntity3);
			} else {
				$this->_oCache->remove($oEntity3->identity_get());
			}
			return;
		}
		if($oSource === $this->_oGame->onEntityNew) {
			if($this->_test($oEntity)) {
				$this->_oCache->set($oEntity->identity_get(), $oEntity);
			}
			return;
		}
		if($oSource === $this->_oGame->onEntityDispose) {
			$this->_oCache->remove($oEntity->identity_get());
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
	function __toString() { return 'mygame.game.query.EntityQuery'; }
}
