<?php

class mygame_game_misc_PositionDistance {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->_iLoop = null;
		$this->_moDelta = new haxe_ds_IntMap();
	}}
	public $_iLoop;
	public $_moDelta;
	public function delta_get($oPosition1, $oPosition2) {
		$iId1 = $oPosition1->unit_get()->identity_get();
		$iId2 = $oPosition2->unit_get()->identity_get();
		if($this->_iLoop !== $oPosition1->unit_get()->mygame_get()->loopId_get()) {
			$this->_moDelta = new haxe_ds_IntMap();
		}
		if($this->_moDelta->get($iId1) === null) {
			$this->_moDelta->set($iId1, new haxe_ds_IntMap());
			$this->_moDelta->set($iId2, new haxe_ds_IntMap());
		}
		if($this->_moDelta->get($iId1)->get($iId2) === null) {
			$oVector = $oPosition2->hclone();
			$oVector->vector_add($oPosition1->hclone()->mult(-1));
			$this->_moDelta->get($iId1)->set($iId2, $oVector);
			$oVector->mult(-1);
			$this->_moDelta->get($iId2)->set($iId1, $oVector);
		}
		return $this->_moDelta->get($iId1)->get($iId2);
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
	function __toString() { return 'mygame.game.misc.PositionDistance'; }
}
