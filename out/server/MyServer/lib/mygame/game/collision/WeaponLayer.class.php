<?php

class mygame_game_collision_WeaponLayer {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->_oCollisionEvent = null;
		$this->_loUnit = new HList();
		$this->onCollision = new trigger_eventdispatcher_EventDispatcher();
	}}
	public $_loUnit;
	public $_oCollisionEvent;
	public $onCollision;
	public $onUncollision;
	public function add($oUnit) {
		$this->_loUnit->add($oUnit);
	}
	public function remove($oUnit) {
		$this->_loUnit->remove($oUnit);
	}
	public function collisionEventLast_get() {
		return $this->_oCollisionEvent;
	}
	public function collision_check() {
		$iCollisionQuantity = 0;
		if(null == $this->_loUnit) throw new HException('null iterable');
		$__hx__it = $this->_loUnit->iterator();
		while($__hx__it->hasNext()) {
			unset($oUnit);
			$oUnit = $__hx__it->next();
			if(null == $this->_loUnit) throw new HException('null iterable');
			$__hx__it2 = $this->_loUnit->iterator();
			while($__hx__it2->hasNext()) {
				unset($oTarget);
				$oTarget = $__hx__it2->next();
				$oWeapon = $oUnit->ability_get(_hx_qtype("mygame.game.ability.Weapon"));
				if($oWeapon === null) {
					continue;
				}
				$oWeapon->target_suggest($oTarget);
				unset($oWeapon);
			}
		}
		return $iCollisionQuantity;
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
	function __toString() { return 'mygame.game.collision.WeaponLayer'; }
}
