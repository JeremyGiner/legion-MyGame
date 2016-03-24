<?php

class mygame_game_query_UnitQuery implements legion_IQuery{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_iLoop = -1;
		$this->_oGame = $oGame;
		$this->_oCache = new haxe_ds_StringMap();
	}}
	public $_oGame;
	public $_oCache;
	public $_iLoop;
	public $_oFilter;
	public function data_get($aUnit) {
		$this->_oFilter = $aUnit;
		$lUnit = new HList();
		{
			$_g = 0;
			$_g1 = $this->_oGame->entity_get_all();
			while($_g < $_g1->length) {
				$oUnit = $_g1[$_g];
				++$_g;
				if(!Std::is($oUnit, _hx_qtype("mygame.game.entity.Unit"))) {
					continue;
				}
				if(!$this->_test($oUnit)) {
					continue;
				}
				$lUnit->add($oUnit);
				unset($oUnit);
			}
		}
		return $lUnit;
	}
	public function _cache_update() {
		if($this->_iLoop === $this->_oGame->loopId_get()) {
			return;
		}
		$this->_iLoop === $this->_oGame->loopId_get();
		$this->_oCache = new haxe_ds_StringMap();
	}
	public function _test($oUnit) {
		if($this->_oFilter->exists("type")) {
			$_oType = $this->_oFilter->get("type");
			if(!Std::is($oUnit, $_oType)) {
				return false;
			}
		}
		if($this->_oFilter->exists("ability")) {
			$_oType1 = $this->_oFilter->get("ability");
			if($oUnit->ability_get($_oType1) === null) {
				return false;
			}
		}
		if($this->_oFilter->exists("owner")) {
			$_oPlayer = $this->_oFilter->get("owner");
			if(!_hx_equal($oUnit->owner_get(), $_oPlayer)) {
				return false;
			}
		}
		return true;
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
	function __toString() { return 'mygame.game.query.UnitQuery'; }
}
