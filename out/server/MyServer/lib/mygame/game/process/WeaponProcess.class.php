<?php

class mygame_game_process_WeaponProcess implements trigger_ITrigger{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_oGame = $oGame;
		$this->_lWeapon = new HList();
		$this->onTargeting = new trigger_EventDispatcher2();
		$this->onFiring = new trigger_EventDispatcher2();
		$this->_oGame->onLoop->attach($this);
	}}
	public $_oGame;
	public $_lWeapon;
	public $onTargeting;
	public $onFiring;
	public function entity_add($oEntity) {
		if(Std::is($oEntity, _hx_qtype("mygame.game.entity.Unit"))) {
			$oUnit = $oEntity;
			$oWeapon = $oUnit->ability_get(_hx_qtype("mygame.game.ability.Weapon"));
			if($oWeapon !== null) {
				$this->_lWeapon->push($oWeapon);
			}
			return true;
		}
		return false;
	}
	public function trigger($oSource) {
		if($oSource === $this->_oGame->onLoop) {
			$this->onTargeting->dispatch($this->_oGame);
			$this->onFiring->dispatch($this->_oGame);
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
