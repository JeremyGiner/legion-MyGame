<?php

class mygame_game_ability_Platoon extends mygame_game_ability_UnitAbility {
	public function __construct($oUnit) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oUnit);
		$this->_aSubUnit = new _hx_array(array());
		{
			$_g = 0;
			while($_g < 9) {
				$i = $_g++;
				$oSubPosition = $this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Position"))->hclone();
				switch($i) {
				case 0:{
					$oSubPosition->add(0, 0);
				}break;
				case 1:{
					$oSubPosition->add(-4000, 0);
				}break;
				case 2:{
					$oSubPosition->add(4000, 0);
				}break;
				case 3:{
					$oSubPosition->add(4000, 4000);
				}break;
				case 4:{
					$oSubPosition->add(-4000, -4000);
				}break;
				case 5:{
					$oSubPosition->add(4000, -4000);
				}break;
				case 6:{
					$oSubPosition->add(-4000, 4000);
				}break;
				case 7:{
					$oSubPosition->add(0, 4000);
				}break;
				case 8:{
					$oSubPosition->add(0, -4000);
				}break;
				}
				$this->_aSubUnit->push(new mygame_game_entity_SubUnit($oUnit, $oSubPosition));
				unset($oSubPosition,$i);
			}
		}
		$this->_oPlatoonGuidance = $this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Guidance"));
		if($this->_oPlatoonGuidance === null) {
			haxe_Log::trace("[ERROR] unit with platoon ability require GuidancePlatoon", _hx_anonymous(array("fileName" => "Platoon.hx", "lineNumber" => 46, "className" => "mygame.game.ability.Platoon", "methodName" => "new")));
		}
	}}
	public $_aSubUnit;
	public $_oPlatoonGuidance;
	public function subUnit_get() {
		$a = $this->_aSubUnit->copy();
		{
			$_g = 0;
			while($_g < $a->length) {
				$o = $a[$_g];
				++$_g;
				if($o->dispose_check()) {
					$this->_aSubUnit->remove($o);
				}
				unset($o);
			}
		}
		return $this->_aSubUnit;
	}
	public function offset_get($iKey) {
		$iPitch = _hx_mod(3, $this->_aSubUnit->length);
		return new space_Vector2i(_hx_mod($iKey, $iPitch), Math::floor($iKey / $iPitch));
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
	function __toString() { return 'mygame.game.ability.Platoon'; }
}
