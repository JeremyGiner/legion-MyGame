<?php

class mygame_game_ability_GuidanceMissile extends mygame_game_ability_Guidance {
	public function __construct($oEntity, $iTargetId) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oEntity);
		$this->_oEntity = $oEntity;
		$this->_iTargetId = $iTargetId;
	}}
	public $_iTargetId;
	public $_oEntity;
	public $_oTarget;
	public function target_get() {
		if($this->_iTargetId === -1) {
			return null;
		}
		$oTarget = $this->_oEntity->game_get()->entity_get($this->_iTargetId);
		if($oTarget === null || $oTarget->ability_get(_hx_qtype("mygame.game.ability.Position")) === null) {
			$this->_iTargetId = -1;
		}
		$this->_oTarget = $oTarget;
		return $oTarget;
	}
	public function process() {
		$oTarget = $this->target_get();
		if($oTarget === null) {
			$this->_oEntity->ability_get(_hx_qtype("mygame.game.ability.Mobility"))->force_set("self", 0, 0, true);
			return;
		}
		$oVector = $this->_vector_get();
		$this->_oMobility->force_set("self", $oVector->x, $oVector->y, true);
	}
	public function _vector_get() {
		$oDelta = $this->_oTarget->ability_get(_hx_qtype("mygame.game.ability.Position"))->hclone();
		$oDelta->vector_add($this->_oEntity->ability_get(_hx_qtype("mygame.game.ability.Position"))->hclone()->mult(-1));
		return $oDelta;
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
	function __toString() { return 'mygame.game.ability.GuidanceMissile'; }
}
