<?php

class mygame_game_process_WeaponProcess implements trigger_ITrigger{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_oGame = $oGame;
		$this->_oQueryWeapon = new mygame_game_query_EntityQuery($this->_oGame, mygame_game_process_WeaponProcess_0($this, $oGame));
		$this->_oGame->onLoop->attach($this);
	}}
	public $_oGame;
	public $_oQueryWeapon;
	public function trigger($oSource) {
		if($oSource === $this->_oGame->onLoop) {
			$aEntity = $this->_oQueryWeapon->data_get(null);
			if(null == $aEntity) throw new HException('null iterable');
			$__hx__it = $aEntity->iterator();
			while($__hx__it->hasNext()) {
				unset($oEntity);
				$oEntity = $__hx__it->next();
				$oEntity->ability_get(_hx_qtype("mygame.game.ability.Weapon"))->swipe_target();
			}
			if(null == $aEntity) throw new HException('null iterable');
			$__hx__it = $aEntity->iterator();
			while($__hx__it->hasNext()) {
				unset($oEntity1);
				$oEntity1 = $__hx__it->next();
				$oEntity1->ability_get(_hx_qtype("mygame.game.ability.Weapon"))->fire();
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
	function __toString() { return 'mygame.game.process.WeaponProcess'; }
}
function mygame_game_process_WeaponProcess_0(&$__hx__this, &$oGame) {
	{
		$_g = new haxe_ds_StringMap();
		$_g->set("ability", _hx_qtype("mygame.game.ability.Weapon"));
		return $_g;
	}
}
