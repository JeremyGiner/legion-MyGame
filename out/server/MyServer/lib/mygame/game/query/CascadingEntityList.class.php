<?php

class mygame_game_query_CascadingEntityList extends utils_CascadingValue {
	public function __construct($oGame, $aVali) {
		if(!php_Boot::$skip_constructor) {
		$this->_aVali = $aVali;
		$this->_oGame = $oGame;
		$this->_mCascadingChildrenQueue = new haxe_ds_IntMap();
		$this->_mCascadingChildren = new haxe_ds_IntMap();
		parent::__construct((new _hx_array(array($this->_oGame->onEntityNew, $this->_oGame->onEntityDispose))));
		$this->_oValue = new haxe_ds_IntMap();
		if(null == $this->_oGame->entity_get_all()) throw new HException('null iterable');
		$__hx__it = $this->_oGame->entity_get_all()->iterator();
		while($__hx__it->hasNext()) {
			unset($o);
			$o = $__hx__it->next();
			$this->_entity_init($o);
		}
	}}
	public $_oGame;
	public $_aVali;
	public $_mCascadingChildrenQueue;
	public $_mCascadingChildren;
	public function _entity_init($o) {
		$oCasca = new mygame_game_utils_CascadingValiEntityCompoAnd($o, $this->_aVali);
		$this->_aDispatcher->push($oCasca->onUpdate);
		$oCasca->onUpdate->attach($this);
		$this->_mCascadingChildren->set($o->identity_get(), $oCasca);
		$this->_mCascadingChildrenQueue->set($o->identity_get(), $oCasca);
	}
	public function _update() {
		if(null == $this->_mCascadingChildrenQueue) throw new HException('null iterable');
		$__hx__it = $this->_mCascadingChildrenQueue->iterator();
		while($__hx__it->hasNext()) {
			unset($oCasca);
			$oCasca = $__hx__it->next();
			$oEntity = $oCasca->entity_get();
			if($oCasca->get() === true) {
				$this->_oValue->set($oEntity->identity_get(), $oEntity);
			} else {
				$this->_oValue->remove($oEntity->identity_get());
			}
			unset($oEntity);
		}
		$this->_mCascadingChildrenQueue = new haxe_ds_IntMap();
	}
	public function trigger($oSource) {
		if($oSource === $this->_oGame->onEntityNew) {
			$this->_entity_init($this->_oGame->onEntityNew->event_get());
		} else {
			if($oSource === $this->_oGame->onEntityDispose) {
				$o = $this->_oGame->onEntityDispose->event_get();
				$iKey = $o->identity_get();
				$oCasca = $this->_mCascadingChildren->get($iKey);
				$oCasca->onUpdate->remove($this);
				$this->_aDispatcher->remove($oCasca->onUpdate);
				$this->_oValue->remove($iKey);
				$this->_mCascadingChildren->remove($iKey);
				$this->_mCascadingChildrenQueue->remove($iKey);
			} else {
				$oCasca1 = $oSource->event_get();
				$this->_mCascadingChildrenQueue->set($oCasca1->entity_get()->identity_get(), $oCasca1);
			}
		}
		parent::trigger($oSource);
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
	function __toString() { return 'mygame.game.query.CascadingEntityList'; }
}
