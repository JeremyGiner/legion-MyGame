<?php

class mygame_game_process_DeathPlatoon implements trigger_ITrigger{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_oGame = $oGame;
		$this->_oQueryPlatoon = new mygame_game_query_EntityQuery($this->_oGame, new mygame_game_query_ValidatorEntity(mygame_game_process_DeathPlatoon_0($this, $oGame)), null);
		$this->_oGame->onLoop->attach($this);
	}}
	public $_oGame;
	public $_oQueryPlatoon;
	public function process() {
		if(null == $this->_oQueryPlatoon->data_get(null)) throw new HException('null iterable');
		$__hx__it = $this->_oQueryPlatoon->data_get(null)->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity);
			$oEntity = $__hx__it->next();
			if($oEntity->ability_get(_hx_qtype("mygame.game.ability.Platoon"))->subUnit_get()->length !== 0) {
				continue;
			}
			$oEntity->game_get()->entity_remove($oEntity);
		}
	}
	public function trigger($oSource) {
		if($oSource === $this->_oGame->onLoop) {
			$this->process();
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
	function __toString() { return 'mygame.game.process.DeathPlatoon'; }
}
function mygame_game_process_DeathPlatoon_0(&$__hx__this, &$oGame) {
	{
		$_g = new haxe_ds_StringMap();
		$_g->set("ability", _hx_qtype("mygame.game.ability.Platoon"));
		return $_g;
	}
}
