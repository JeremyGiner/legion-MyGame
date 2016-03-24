<?php

class mygame_game_collision_UnitTile {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->_loUnit = new HList();
		$this->onCollision = new trigger_EventDispatcher2();
	}}
	public function collision_check() {
		$iCollisionQuantity = 0;
		if(null == $this->_loUnit) throw new HException('null iterable');
		$__hx__it = $this->_loUnit->iterator();
		while($__hx__it->hasNext()) {
			$oUnit = $__hx__it->next();
			$oPosition = $oUnit->ability_get(_hx_qtype("mygame.game.ability.Position"));
			$oPlan = $oUnit->ability_get(_hx_qtype("mygame.game.ability.PositionPlan"));
			$loTile = $oPosition->map_get()->tileList_gather($oPosition->tile_get());
			$oCollisionMin = null;
			$oTileMin = null;
			if(null == $loTile) throw new HException('null iterable');
			$__hx__it2 = $loTile->iterator();
			while($__hx__it2->hasNext()) {
				$oTile = $__hx__it2->next();
				if($oPlan->tile_check($oTile)) {
					continue;
				}
				$oCollision = collider_CollisionCheckerPrior::check($oUnit->ability_get(_hx_qtype("mygame.game.ability.Volume"))->geometry_get(), $oUnit->ability_get(_hx_qtype("mygame.game.ability.Mobility"))->velocity_get(), $oTile->geometry_get(), null);
				if($oCollision !== null) {
					if($oCollisionMin === null) {
						$oCollisionMin = $oCollision;
						$oTileMin = $oTile;
					} else {
						if($oCollision->time_get() < $oCollisionMin->time_get()) {
							$oCollisionMin = $oCollision;
							$oTileMin = $oTile;
						}
					}
				}
				unset($oCollision);
			}
			if($oCollisionMin !== null) {
				$iCollisionQuantity++;
				$this->_oCollisionEvent = $oCollisionMin;
				$this->onCollision->dispatch($oCollisionMin);
			}
			unset($oTileMin,$oPosition,$oPlan,$oCollisionMin,$loTile);
		}
		return $iCollisionQuantity;
	}
	public function collisionEventLast_get() {
		return $this->_oCollisionEvent;
	}
	public function remove($oUnit) {
		$this->_loUnit->remove($oUnit);
	}
	public function add($oUnit) {
		$this->_loUnit->add($oUnit);
	}
	public $onCollision;
	public $_oCollisionEvent = null;
	public $_loUnit;
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
	function __toString() { return 'mygame.game.collision.UnitTile'; }
}
