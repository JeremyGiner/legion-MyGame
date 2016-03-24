<?php

class mygame_game_process_MobilityMapClamp implements trigger_ITrigger{
	public function __construct($oCLayerUnitTile) {
		if(!php_Boot::$skip_constructor) {
		$this->_oCLayerUnitTile = $oCLayerUnitTile;
		$this->_oCLayerUnitTile->onCollision->attach($this);
	}}
	public function trigger($oSource) {
		if($oSource !== $this->_oCLayerUnitTile->onCollision) {
			return;
		}
		$oCollisionEvent = $this->_oCLayerUnitTile->onCollision->event_get();
		if($oCollisionEvent->time_get() <= 1 && $oCollisionEvent->time_get() >= 0) {
			$oBoxA = $oCollisionEvent->shapeA_get();
			$oVect = $oCollisionEvent->velocityA_get()->hclone();
			$oVect->mult($oCollisionEvent->time_get());
			$oVect->length_set(Math::max(0, $oVect->length_get() - 0.1));
			$oBoxA->center_get()->add($oVect->x, $oVect->y, 0);
			if(_hx_equal($oCollisionEvent->normal_get()->x, 1)) {
				$oCollisionEvent->velocityA_get()->x = 0;
				$oCollisionEvent->velocityA_get()->y *= $oCollisionEvent->time_get();
			} else {
				$oCollisionEvent->velocityA_get()->x *= $oCollisionEvent->time_get();
				$oCollisionEvent->velocityA_get()->y = 0;
			}
			if($this->_oCLayerUnitTile->collision_check() !== 0) {
				haxe_Log::trace("ERROR!!", _hx_anonymous(array("fileName" => "MobilityMapClamp.hx", "lineNumber" => 77, "className" => "mygame.game.process.MobilityMapClamp", "methodName" => "trigger")));
				haxe_Log::trace("ERROR!!", _hx_anonymous(array("fileName" => "MobilityMapClamp.hx", "lineNumber" => 78, "className" => "mygame.game.process.MobilityMapClamp", "methodName" => "trigger")));
			}
		}
	}
	public function clamp() {
	}
	public $_oCLayerUnitTile;
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
	function __toString() { return 'mygame.game.process.MobilityMapClamp'; }
}
