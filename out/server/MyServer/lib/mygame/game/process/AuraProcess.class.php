<?php

class mygame_game_process_AuraProcess implements trigger_ITrigger{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_oGame = $oGame;
		$this->_oQuerySpawnShield = new mygame_game_query_EntityQuery($this->_oGame, new mygame_game_query_ValidatorEntity(mygame_game_process_AuraProcess_0($this, $oGame)), null);
		$this->_oQueryDivineShield = new mygame_game_query_EntityQuery($this->_oGame, new mygame_game_query_ValidatorEntity(mygame_game_process_AuraProcess_1($this, $oGame)), null);
		$this->_oGame->onLoop->attach($this);
	}}
	public $_oGame;
	public $_oQuerySpawnShield;
	public $_oQueryDivineShield;
	public function process() {
		$lExpired = new HList();
		if(null == $this->_oQueryDivineShield->data_get(null)) throw new HException('null iterable');
		$__hx__it = $this->_oQueryDivineShield->data_get(null)->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity0);
			$oEntity0 = $__hx__it->next();
			if($oEntity0->ability_get(_hx_qtype("mygame.game.ability.DivineShield"))->expired_check()) {
				$lExpired->push($oEntity0);
			}
		}
		if(null == $lExpired) throw new HException('null iterable');
		$__hx__it = $lExpired->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity);
			$oEntity = $__hx__it->next();
			$oEntity->ability_remove(_hx_qtype("mygame.game.ability.DivineShield"));
		}
		if(null == $this->_oQuerySpawnShield->data_get(null)) throw new HException('null iterable');
		$__hx__it = $this->_oQuerySpawnShield->data_get(null)->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity01);
			$oEntity01 = $__hx__it->next();
			$oSpawnShield = $oEntity01->ability_get(_hx_qtype("mygame.game.ability.SpawnShield"));
			$l = $this->_oGame->singleton_get(_hx_qtype("mygame.game.query.EntityDistance"))->entityList_get_byProximity($oSpawnShield->unit_get(), $oSpawnShield->radius_get());
			if(null == $l) throw new HException('null iterable');
			$__hx__it2 = $l->iterator();
			while($__hx__it2->hasNext()) {
				unset($oEntity1);
				$oEntity1 = $__hx__it2->next();
				if(!$oSpawnShield->target_check($oEntity1)) {
					continue;
				}
				$oSpawnShield->effect_apply($oEntity1);
			}
			unset($oSpawnShield,$l);
		}
	}
	public function trigger($oSource) {
		$this->process();
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
	function __toString() { return 'mygame.game.process.AuraProcess'; }
}
function mygame_game_process_AuraProcess_0(&$__hx__this, &$oGame) {
	{
		$_g = new haxe_ds_StringMap();
		$_g->set("ability", _hx_qtype("mygame.game.ability.SpawnShield"));
		return $_g;
	}
}
function mygame_game_process_AuraProcess_1(&$__hx__this, &$oGame) {
	{
		$_g1 = new haxe_ds_StringMap();
		$_g1->set("ability", _hx_qtype("mygame.game.ability.DivineShield"));
		return $_g1;
	}
}
