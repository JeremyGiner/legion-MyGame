<?php

class mygame_game_query_WatcherRangeEntity implements trigger_IEventDispatcher, trigger_ITrigger{
	public function __construct($oQueryEntityDistance) {
		if(!php_Boot::$skip_constructor) {
		$this->_oQueryEntityDistance = $oQueryEntityDistance;
		$this->_mTrigger = new haxe_ds_IntMap();
		$this->_mTriggerRouter = new haxe_ds_StringMap();
		$this->_iKeyGen = 0;
		$this->_oEventLast = null;
		$this->_oQueryEntityDistance->onUpdate->attach($this);
	}}
	public $_mTrigger;
	public $_mTriggerRouter;
	public $_iKeyGen;
	public $_oQueryEntityDistance;
	public $_oEventLast;
	public function nextID_get() {
		return $this->_iKeyGen;
	}
	public function event_get() {
		return $this->_oEventLast;
	}
	public function attach($oTrigger) {
		$this->_mTrigger->set($this->_iKeyGen, $oTrigger);
		$this->_iKeyGen++;
	}
	public function remove($oTrigger) {
		if(null == $this->_mTrigger) throw new HException('null iterable');
		$__hx__it = $this->_mTrigger->keys();
		while($__hx__it->hasNext()) {
			unset($iKey);
			$iKey = $__hx__it->next();
			if($this->_mTrigger->get($iKey) === $oTrigger) {
				$this->_mTrigger->remove($iKey);
			}
		}
		if(null == $this->_mTriggerRouter) throw new HException('null iterable');
		$__hx__it = $this->_mTriggerRouter->iterator();
		while($__hx__it->hasNext()) {
			unset($l);
			$l = $__hx__it->next();
			$l->remove($oTrigger);
		}
	}
	public function listen($iTriggerKey, $aValue) {
		$sKey = $this->_key_get($aValue[0], $aValue[1]);
		if(!$this->_mTriggerRouter->exists($sKey)) {
			$this->_mTriggerRouter->set($sKey, new HList());
		}
		$oTrigger = $this->_mTrigger->get($iTriggerKey);
		$l = $this->_mTriggerRouter->get($sKey);
		if(null == $l) throw new HException('null iterable');
		$__hx__it = $l->iterator();
		while($__hx__it->hasNext()) {
			unset($oTrigger_);
			$oTrigger_ = $__hx__it->next();
			if($oTrigger_ === $oTrigger) {
				return;
			}
		}
		$this->_mTriggerRouter->get($sKey)->push($oTrigger);
	}
	public function _key_get($oEntity0, $oEntity1) {
		if($oEntity0->identity_get() > $oEntity1->identity_get()) {
			return _hx_string_rec($oEntity1->identity_get(), "") . ":" . _hx_string_rec($oEntity0->identity_get(), "");
		} else {
			return _hx_string_rec($oEntity0->identity_get(), "") . ":" . _hx_string_rec($oEntity1->identity_get(), "");
		}
	}
	public function trigger($oSource) {
		$aEntity = $oSource->event_get();
		$this->_oEventLast = $aEntity;
		$l = $this->_mTriggerRouter->get($this->_key_get($aEntity[0], $aEntity[1]));
		if($l === null) {
			return;
		}
		if(null == $l) throw new HException('null iterable');
		$__hx__it = $l->iterator();
		while($__hx__it->hasNext()) {
			unset($o);
			$o = $__hx__it->next();
			$o->trigger($this);
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
	function __toString() { return 'mygame.game.query.WatcherRangeEntity'; }
}
