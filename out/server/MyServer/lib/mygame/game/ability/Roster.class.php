<?php

class mygame_game_ability_Roster extends legion_ability_Ability {
	public function __construct($oGame, $aUnitType) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->_oFactory = null;
		$this->_aUnitActive = new _hx_array(array());
		$this->_aUnitType = $aUnitType;
	}}
	public $_aUnitType;
	public $_aUnitActive;
	public $_oFactory;
	public function unitType_get($iIndex) {
		return $this->_aUnitType[$iIndex];
	}
	public function unitType_get_all() {
		return $this->_aUnitType;
	}
	public function activeUnit_get($iIndex) {
		return $this->_aUnitActive[$iIndex];
	}
	public function activeUnit_get_all() {
		return $this->_aUnitActive;
	}
	public function factory_get() {
		return $this->_oFactory;
	}
	public function factory_set($oEntity) {
		$this->_oFactory = $oEntity;
	}
	public function build($iIndex) {
		$this->_oFactory->ability_get(_hx_qtype("mygame.game.ability.Loyalty"))->owner_get()->credit_add(-mygame_game_ability_Roster::price_get($this->_aUnitType[$iIndex]));
		$oProduct = Type::createInstance(Type::resolveClass($this->_aUnitType[$iIndex]), (new _hx_array(array($this->_oFactory->game_get(), $this->_oFactory->ability_get(_hx_qtype("mygame.game.ability.Loyalty"))->owner_get(), $this->_oFactory->ability_get(_hx_qtype("mygame.game.ability.Position"))))));
		$this->_oFactory->game_get()->entity_add($oProduct);
		$this->_aUnitActive[$iIndex] = $oProduct;
		$_oRallyPoint = $this->_oFactory->ability_get(_hx_qtype("mygame.game.ability.Position"))->hclone();
		$_oRallyPoint->y -= 4999;
		$oProduct->ability_get(_hx_qtype("mygame.game.ability.Guidance"))->waypoint_set($_oRallyPoint);
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
	static function price_get($sUnitType) {
		switch($sUnitType) {
		case "mygame.game.entity.Soldier":{
			return 10;
		}break;
		case "mygame.game.entity.Bazoo":{
			return 20;
		}break;
		}
		return 11;
	}
	function __toString() { return 'mygame.game.ability.Roster'; }
}
