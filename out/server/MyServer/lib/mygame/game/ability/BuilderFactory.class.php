<?php

class mygame_game_ability_BuilderFactory extends mygame_game_ability_Builder {
	public function __construct($oUnit) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oUnit);
		$oPosition = $this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Position"));
		if($oPosition === null) {
			throw new HException("[ERROR]:buy:seller must have Position ability.");
		}
		$this->_oPosition = $oPosition->hclone();
		$this->_oRallyPoint = $this->_oPosition->hclone();
		$this->_oRallyPoint->y -= 4999;
	}}
	public $_oPosition;
	public $_oRallyPoint;
	public function offerArray_get() {
		return mygame_game_ability_BuilderFactory::$_aOffer;
	}
	public function buy($iOfferIndex) {
		if($iOfferIndex < 0 || $iOfferIndex >= mygame_game_ability_BuilderFactory::$_aOffer->length) {
			throw new HException("[ERROR]:" . _hx_string_rec($iOfferIndex, "") . " is an invalide offer index.");
		}
		if($this->_oUnit->owner_get() === null) {
			throw new HException("[ERROR]:neutral unit can not sell.");
		}
		$this->_oUnit->owner_get()->credit_add(-_hx_array_get(mygame_game_ability_BuilderFactory::$_aOffer, $iOfferIndex)->cost_get());
		$oProduct = $this->unit_create(mygame_game_ability_BuilderFactory::$_aOffer[$iOfferIndex]);
		$oGuidance = $oProduct->ability_get(_hx_qtype("mygame.game.ability.Guidance"));
		if($oGuidance === null) {
			throw new HException("[ERROR]:buy:product must have Guidance ability.");
		}
		$oGuidance->goal_set($this->_oRallyPoint);
	}
	public function unit_create($oOffer) {
		$oUnit = Type::createInstance(Type::resolveClass($oOffer->data_get()), (new _hx_array(array($this->_oUnit->game_get(), $this->_oUnit->owner_get(), $this->_oPosition))));
		$this->_oUnit->game_get()->entity_add($oUnit);
		return $oUnit;
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
	static $_aOffer;
	function __toString() { return 'mygame.game.ability.BuilderFactory'; }
}
mygame_game_ability_BuilderFactory::$_aOffer = (new _hx_array(array(new mygame_game_misc_offer_Offer(15, "Build a Solier 2", "mygame.game.entity.PlatoonUnit"), new mygame_game_misc_offer_Offer(15, "Build a Tank", "mygame.game.entity.Tank"))));
