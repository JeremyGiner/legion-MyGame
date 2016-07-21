<?php

class mygame_game_ability_GuidanceProjectile extends mygame_game_ability_Guidance {
	public function __construct($oEntity, $oTarget) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oEntity);
		$this->_oEntity = $oEntity;
		$this->_oTarget = $oTarget;
	}}
	public $_oTarget;
	public $_oEntity;
	public function process() {
		$oDelta = $this->_oTarget->hclone();
		$oDelta->vector_add($this->_oEntity->ability_get(_hx_qtype("mygame.game.ability.Position"))->hclone()->mult(-1));
		if($oDelta->x === 0 && $oDelta->y === 0) {
			$this->_oEntity->game_get()->entity_remove($this->_oEntity);
			return;
		}
		$this->_oMobility->force_set("self", $oDelta->x, $oDelta->y, true);
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
	function __toString() { return 'mygame.game.ability.GuidanceProjectile'; }
}
