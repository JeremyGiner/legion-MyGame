<?php

class mygame_game_query_EntityQueryAdv implements trigger_ITrigger, legion_IQuery{
	public function __construct($oGame, $aValidator, $aEventDispatcher = null, $aValidatorMap = null, $aEventFilter = null) {
		if(!php_Boot::$skip_constructor) {
		$this->iYes = 0;
		$this->iNope = 0;
		if($aEventFilter !== null) {
			$this->_aEventFilter = $aEventFilter;
		} else {
			$this->_aEventFilter = (new _hx_array(array()));
		}
		$this->_mEntityQueue = new haxe_ds_IntMap();
		if($aValidator->length > 32) {
			throw new HException("length too hight");
		}
		$this->_aValidator = $aValidator;
		$this->_aEventDispatcher = $aEventDispatcher;
		$this->_mValidatorRouter = new haxe_ds_IntMap();
		{
			$_g1 = 0;
			$_g = $aValidatorMap->length;
			while($_g1 < $_g) {
				$i = $_g1++;
				$this->_mValidatorRouter->set($i, $aValidatorMap[$i]);
				unset($i);
			}
		}
		$this->_oGame = $oGame;
		$this->_mCache = null;
		$this->_onSourceNew = $this->_oGame->onEntityNew;
		$this->_onSourceDispose = $this->_oGame->onEntityDispose;
		$this->_onSourceNew->attach($this);
		$this->_onSourceDispose->attach($this);
		{
			$_g2 = 0;
			$_g11 = $this->_aEventDispatcher;
			while($_g2 < $_g11->length) {
				$oEventDispatcher = $_g11[$_g2];
				++$_g2;
				$oEventDispatcher->attach($this);
				unset($oEventDispatcher);
			}
		}
		$this->onNew = new trigger_EventDispatcher2();
		$this->onDispose = new trigger_EventDispatcher2();
	}}
	public $_oGame;
	public $_mCache;
	public $_mCacheValid;
	public $_aValidator;
	public $_aEventFilter;
	public $_aEventDispatcher;
	public $_mValidatorRouter;
	public $_mEntityQueue;
	public $_onSourceNew;
	public $_onSourceDispose;
	public $onNew;
	public $onDispose;
	public $iNope;
	public $iYes;
	public function data_get($o) {
		if($this->_mCache === null) {
			$this->_cache_init();
		}
		$this->_queue_process();
		return $this->_mCache;
	}
	public function _haveNegativeValidation($oValidationCache) {
		$i = $oValidationCache->iCheck ^ 65535 | $oValidationCache->iResult;
		return $i !== 65535;
	}
	public function _validation_init($oEntity) {
		$oValidResult = _hx_anonymous(array("iResult" => 65535, "iCheck" => 65535));
		$bValidation = null;
		$bSkip = false;
		{
			$_g1 = 0;
			$_g = $this->_aValidator->length;
			while($_g1 < $_g) {
				$iValidatorIndex = $_g1++;
				if($bSkip) {
					$oValidResult->iCheck = $this->_bit_clr($oValidResult->iCheck, $iValidatorIndex);
				} else {
					$bValidation = _hx_array_get($this->_aValidator, $iValidatorIndex)->validate($oEntity);
					if($bValidation) {
						$oValidResult->iResult = $this->_bit_set($oValidResult->iResult, $iValidatorIndex);
					} else {
						$oValidResult->iResult = $this->_bit_clr($oValidResult->iResult, $iValidatorIndex);
					}
					if($bValidation === false) {
						$bSkip = true;
					}
				}
				unset($iValidatorIndex);
			}
		}
		$this->_mCacheValid->set($oEntity->identity_get(), $oValidResult);
		if($oValidResult->iResult === 65535 && $oValidResult->iCheck === 65535) {
			$this->_mCache->set($oEntity->identity_get(), $oEntity);
		}
	}
	public function _validation_update($oEntity, $oValidResult) {
		$bValidation = null;
		{
			$_g1 = 0;
			$_g = $this->_aValidator->length;
			while($_g1 < $_g) {
				$iValidatorIndex = $_g1++;
				if($this->_bit_read($oValidResult->iCheck, $iValidatorIndex) === 1) {
					continue;
				}
				$bValidation = _hx_array_get($this->_aValidator, $iValidatorIndex)->validate($oEntity);
				if($bValidation) {
					$oValidResult->iResult = $this->_bit_set($oValidResult->iResult, $iValidatorIndex);
				} else {
					$oValidResult->iResult = $this->_bit_clr($oValidResult->iResult, $iValidatorIndex);
				}
				$oValidResult->iCheck = $this->_bit_set($oValidResult->iCheck, $iValidatorIndex);
				if($bValidation === false) {
					break;
				}
				unset($iValidatorIndex);
			}
		}
	}
	public function _bit_set($i, $iBitIndex) {
		return $i | 1 << $iBitIndex;
	}
	public function _bit_clr($i, $iBitIndex) {
		return $i & ~(1 << $iBitIndex);
	}
	public function _bit_read($i, $iBitIndex) {
		return $i >> $iBitIndex & 1;
	}
	public function _queue_process() {
		$lEntityQueue = utils_MapTool::toList($this->_mEntityQueue);
		if($lEntityQueue->length === 0) {
			return;
		}
		if(null == $lEntityQueue) throw new HException('null iterable');
		$__hx__it = $lEntityQueue->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity);
			$oEntity = $__hx__it->next();
			$oValidResult = $this->_mCacheValid->get($oEntity->identity_get());
			$this->_validation_update($oEntity, $oValidResult);
			if($oValidResult->iResult === 65535 && $oValidResult->iCheck === 65535) {
				$this->_mCache->set($oEntity->identity_get(), $oEntity);
			} else {
				$this->_mCache->remove($oEntity->identity_get());
			}
			unset($oValidResult);
		}
		$this->_mEntityQueue = new haxe_ds_IntMap();
	}
	public function _cache_init() {
		$this->_mCache = new haxe_ds_IntMap();
		$this->_mCacheValid = new haxe_ds_IntMap();
		if(null == $this->_oGame->entity_get_all()) throw new HException('null iterable');
		$__hx__it = $this->_oGame->entity_get_all()->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity);
			$oEntity = $__hx__it->next();
			$this->_validation_init($oEntity);
		}
	}
	public function _something($oEntity, $iEventDispatcherIndex) {
		$oValidResult = $this->_mCacheValid->get($oEntity->identity_get());
		$aValidatorMapped = $this->_mValidatorRouter->get($iEventDispatcherIndex);
		{
			$_g = 0;
			while($_g < $aValidatorMapped->length) {
				$iValidatorIndex = $aValidatorMapped[$_g];
				++$_g;
				$oValidResult->iCheck = $this->_bit_clr($oValidResult->iCheck, $iValidatorIndex);
				unset($iValidatorIndex);
			}
		}
		if($this->_haveNegativeValidation($oValidResult)) {
			return;
		}
		{
			$key = $oEntity->identity_get();
			$this->_mEntityQueue->set($key, $oEntity);
		}
	}
	public function trigger($oSource) {
		if($this->_mCache === null) {
			return;
		}
		if($oSource === $this->_onSourceNew) {
			$this->_validation_init($this->_onSourceNew->event_get());
			return;
		}
		if($oSource === $this->_onSourceDispose) {
			$oEntity = $this->_onSourceDispose->event_get();
			$this->_mCache->remove($oEntity->identity_get());
			$this->_mCacheValid->remove($oEntity->identity_get());
			{
				$key = $oEntity->identity_get();
				$this->_mEntityQueue->remove($key);
			}
			return;
		}
		$iEventDispatcherIndex = null;
		if($this->_aEventDispatcher[3] === $oSource) {
			$iEventDispatcherIndex = 3;
		} else {
			$_g1 = 0;
			$_g = $this->_aEventDispatcher->length;
			while($_g1 < $_g) {
				$i = $_g1++;
				if($this->_aEventDispatcher[$i] === $oSource) {
					$iEventDispatcherIndex = $i;
				}
				unset($i);
			}
		}
		if($this->_aEventFilter[$iEventDispatcherIndex] !== null && !_hx_array_get($this->_aEventFilter, $iEventDispatcherIndex)->validate($oSource->event_get())) {
			$this->iNope++;
			return;
		}
		$this->iYes++;
		$oEntity1 = null;
		if(Std::is($oSource->event_get(), _hx_qtype("Array"))) {
			$aEntity = $oSource->event_get();
			{
				$_g2 = 0;
				while($_g2 < $aEntity->length) {
					$oEntity2 = $aEntity[$_g2];
					++$_g2;
					$this->_something($oEntity2, $iEventDispatcherIndex);
					unset($oEntity2);
				}
			}
			return;
		} else {
			if(Std::is($oSource->event_get(), _hx_qtype("legion.entity.Entity"))) {
				$oEntity1 = $oSource->event_get();
			} else {
				if(Std::is($oSource->event_get(), _hx_qtype("mygame.game.ability.Position"))) {
					$oEntity1 = $oSource->event_get()->unit_get();
				} else {
					if(Std::is($oSource->event_get(), _hx_qtype("mygame.game.ability.EntityAbility"))) {
						$oEntity1 = $oSource->event_get()->entity_get();
					} else {
						if(Std::is($oSource->event_get(), _hx_qtype("mygame.game.ability.UnitAbility"))) {
							$oEntity1 = $oSource->event_get()->unit_get();
						} else {
							$oEntity1 = $oSource->event_get()->entity;
						}
					}
				}
			}
		}
		$this->_something($oEntity1, $iEventDispatcherIndex);
	}
	public function dispose() {
		$this->_oGame->onEntityNew->remove($this);
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
	function __toString() { return 'mygame.game.query.EntityQueryAdv'; }
}
