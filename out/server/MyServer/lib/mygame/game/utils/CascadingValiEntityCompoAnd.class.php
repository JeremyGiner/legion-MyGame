<?php

class mygame_game_utils_CascadingValiEntityCompoAnd extends utils_CascadingValue {
	public function __construct($oEntity, $aVali) {
		if(!php_Boot::$skip_constructor) {
		$this->_oEntity = $oEntity;
		$this->_aVali = $aVali;
		$this->_aCascadingVali = new _hx_array(array());
		parent::__construct((new _hx_array(array())));
		$this->_oValue = true;
		{
			$_g1 = 0;
			$_g = $this->_aVali->length;
			while($_g1 < $_g) {
				$i = $_g1++;
				$this->_aCascadingVali[$i] = new mygame_game_utils_CascadingValiEntity($this->_oEntity, $this->_aVali[$i], $this->_resolve($this->_oEntity, $this->_aVali[$i]));
				_hx_array_get($this->_aCascadingVali, $i)->onUpdate->attach($this);
				$this->_aDispatcher->push(_hx_array_get($this->_aCascadingVali, $i)->onUpdate);
				$this->_oValue = $this->_oValue && _hx_array_get($this->_aCascadingVali, $i)->get();
				if($this->_oValue === false) {
					break;
				}
				unset($i);
			}
		}
	}}
	public $_oEntity;
	public $_aVali;
	public $_aCascadingVali;
	public function entity_get() {
		return $this->_oEntity;
	}
	public function _resolve($oEntity, $oVali) {
		$aDispatcher = new _hx_array(array());
		{
			$_g = Type::getClass($oVali);
			switch($_g) {
			case _hx_qtype("mygame.game.utils.validatorentity.ValiInRangeEntityByTile"):{
				$aDispatcher = (new _hx_array(array($oEntity->game_get()->singleton_get(_hx_qtype("mygame.game.query.EntityDistanceTile"))->data_get((new _hx_array(array($oEntity, $oVali->entity_get()))))->onUpdate)));
			}break;
			case _hx_qtype("mygame.game.utils.validatorentity.ValiInRangeEntity"):{
				$aDispatcher = (new _hx_array(array($oEntity->game_get()->singleton_get(_hx_qtype("mygame.game.query.EntityDistance"))->data_get((new _hx_array(array($oEntity, $oVali->entity_get()))))->onUpdate)));
			}break;
			case _hx_qtype("mygame.game.utils.validatorentity.ValiAlliance"):case _hx_qtype("mygame.game.utils.validatorentity.ValiAllianceEntity"):{
				$aDispatcher = (new _hx_array(array($oEntity->ability_get(_hx_qtype("mygame.game.ability.Loyalty"))->onUpdate)));
			}break;
			case _hx_qtype("mygame.game.utils.validatorentity.ValiAbility"):{
				$aDispatcher = (new _hx_array(array($oEntity->onAbilityAdd, $oEntity->onAbilityRemove)));
			}break;
			case _hx_qtype("mygame.game.utils.validatorentity.ValiNotEntity"):{
				$aDispatcher = (new _hx_array(array()));
			}break;
			default:{
				throw new HException("!!!!!!!!!");
			}break;
			}
		}
		return $aDispatcher;
	}
	public function _update() {
		$this->_oValue = true;
		{
			$_g1 = 0;
			$_g = $this->_aVali->length;
			while($_g1 < $_g) {
				$i = $_g1++;
				if($this->_aCascadingVali[$i] === null) {
					$this->_aCascadingVali[$i] = new mygame_game_utils_CascadingValiEntity($this->_oEntity, $this->_aVali[$i], $this->_resolve($this->_oEntity, $this->_aVali[$i]));
					_hx_array_get($this->_aCascadingVali, $i)->onUpdate->attach($this);
					$this->_aDispatcher->push(_hx_array_get($this->_aCascadingVali, $i)->onUpdate);
				}
				$this->_oValue = $this->_oValue && _hx_array_get($this->_aCascadingVali, $i)->get();
				if($this->_oValue === false) {
					break;
				}
				unset($i);
			}
		}
	}
	public function dispose() {
		{
			$_g = 0;
			$_g1 = $this->_aCascadingVali;
			while($_g < $_g1->length) {
				$o = $_g1[$_g];
				++$_g;
				$o->dispose();
				unset($o);
			}
		}
		parent::dispose();
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
	function __toString() { return 'mygame.game.utils.CascadingValiEntityCompoAnd'; }
}
