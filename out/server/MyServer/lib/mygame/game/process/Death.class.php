<?php

class mygame_game_process_Death implements trigger_ITrigger{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_oGame = $oGame;
		$this->_aEntity = new haxe_ds_IntMap();
		$this->_oGame->onLoop->attach($this);
		$this->_oGame->onHealthAnyUpdate->attach($this);
	}}
	public $_oGame;
	public $_aEntity;
	public function process() {
		if(null == $this->_aEntity) throw new HException('null iterable');
		$__hx__it = $this->_aEntity->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity);
			$oEntity = $__hx__it->next();
			if($oEntity->ability_get(_hx_qtype("mygame.game.ability.Health"))->get() > 0) {
				continue;
			}
			$oEntity->game_get()->entity_remove($oEntity);
		}
		$this->_aEntity = new haxe_ds_IntMap();
	}
	public function trigger($oSource) {
		if($oSource === $this->_oGame->onLoop) {
			$this->process();
		}
		if($oSource === $this->_oGame->onHealthAnyUpdate) {
			$oUnit = $this->_oGame->onHealthAnyUpdate->event_get()->unit_get();
			$this->_aEntity->set($oUnit->identity_get(), $oUnit);
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
	function __toString() { return 'mygame.game.process.Death'; }
}
