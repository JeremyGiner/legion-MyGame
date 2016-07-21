<?php

class mygame_game_process_WeaponProcess implements trigger_ITrigger{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_lHit = new HList();
		$this->_oGame = $oGame;
		$this->_oQueryWeapon = new mygame_game_query_EntityQuery($this->_oGame, new mygame_game_query_ValidatorEntity(mygame_game_process_WeaponProcess_0($this, $oGame)), null);
		$this->_aQueryPossibleTarget = new haxe_ds_IntMap();
		$this->_oGame->onLoop->attach($this);
		$this->_oGame->onEntityDispose->attach($this);
		$this->onHit = new trigger_EventDispatcher2();
	}}
	public $_oGame;
	public $_oQueryWeapon;
	public $_aQueryPossibleTarget;
	public $_lHit;
	public $onHit;
	public function hit_add($oHit) {
		$this->_lHit->add($oHit);
	}
	public function _target_process() {
		if(null == $this->_oQueryWeapon->data_get(null)) throw new HException('null iterable');
		$__hx__it = $this->_oQueryWeapon->data_get(null)->iterator();
		while($__hx__it->hasNext()) {
			unset($oEntity);
			$oEntity = $__hx__it->next();
			$oWeapon = $oEntity->ability_get(_hx_qtype("mygame.game.ability.Weapon"));
			if($oWeapon->target_get() !== null) {
				continue;
			}
			$aValidTarget = $this->_queryValidTarget_get($oWeapon)->get();
			if(null == $aValidTarget) throw new HException('null iterable');
			$__hx__it2 = $aValidTarget->iterator();
			while($__hx__it2->hasNext()) {
				unset($oTarget);
				$oTarget = $__hx__it2->next();
				if($oWeapon->type_get()->target_check($oWeapon, $oTarget)) {
					$oWeapon->target_set($oTarget);
					break;
				}
			}
			unset($oWeapon,$aValidTarget);
		}
	}
	public function _hit_process() {
		$oHit = null;
		while(($oHit = $this->_lHit->pop()) !== null) {
			$oTarget = $this->_oGame->entity_get($oHit->targetId_get());
			if($oTarget === null) {
				continue;
			}
			$oHealth = $oTarget->ability_get(_hx_qtype("mygame.game.ability.Health"));
			if($oHealth === null) {
				continue;
			}
			$oHealth->damage($oHit->damage_get(), $oHit->damageType_get());
			$this->onHit->dispatch($oHit);
			unset($oTarget,$oHealth);
		}
	}
	public function _queryValidTarget_get($oWeapon) {
		$iKey = $oWeapon->unit_get()->identity_get();
		if(!$this->_aQueryPossibleTarget->exists($iKey)) {
			$o = new mygame_game_query_CascadingEntityList($this->_oGame, (new _hx_array(array(new mygame_game_utils_validatorentity_ValiAbility(_hx_qtype("mygame.game.ability.Health")), new mygame_game_utils_validatorentity_ValiAbility(_hx_qtype("mygame.game.ability.Position")), new mygame_game_utils_validatorentity_ValiAbility(_hx_qtype("mygame.game.ability.Loyalty")), new mygame_game_utils_validatorentity_ValiAllianceEntity($oWeapon->unit_get(), legion_entity_ALLIANCE::$ennemy), new mygame_game_utils_validatorentity_ValiInRangeEntityByTile($oWeapon->unit_get(), $oWeapon->type_get()->rangeMax_get()), new mygame_game_utils_validatorentity_ValiInRangeEntity($oWeapon->unit_get(), $oWeapon->type_get()->rangeMax_get()), new mygame_game_utils_validatorentity_ValiNotEntity($oWeapon->unit_get())))));
			$this->_aQueryPossibleTarget->set($iKey, $o);
			return $o;
		} else {
			return $this->_aQueryPossibleTarget->get($iKey);
		}
	}
	public function trigger($oSource) {
		if($oSource === $this->_oGame->onEntityDispose) {
			$oEntity = $this->_oGame->onEntityDispose->event_get();
			if($oEntity->ability_get(_hx_qtype("mygame.game.ability.Weapon")) === null) {
				return;
			}
			$iId = $oEntity->identity_get();
			$this->_aQueryPossibleTarget->get($iId)->dispose();
			$this->_aQueryPossibleTarget->remove($iId);
			return;
		}
		if($oSource === $this->_oGame->onLoop) {
			$aEntity = $this->_oQueryWeapon->data_get(null);
			$this->_target_process();
			if(null == $aEntity) throw new HException('null iterable');
			$__hx__it = $aEntity->iterator();
			while($__hx__it->hasNext()) {
				unset($oEntity1);
				$oEntity1 = $__hx__it->next();
				$oEntity1->ability_get(_hx_qtype("mygame.game.ability.Weapon"))->fire();
			}
			$this->_hit_process();
			return;
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
