<?php

class mygame_game_query_CityTile implements legion_IQuery{
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_oGame = $oGame;
		$this->_oCache = new haxe_ds_StringMap();
	}}
	public $_oGame;
	public $_oCache;
	public function data_get($oTile) {
		$s = _hx_string_rec($oTile->x_get(), "") . ";" . _hx_string_rec($oTile->y_get(), "");
		if($this->_oCache->exists($s)) {
			return $this->_oCache->get($s);
		}
		$this->_oCache->set($s, new HList());
		{
			$_g = 0;
			$_g1 = $this->_oGame->entity_get_all();
			while($_g < $_g1->length) {
				$oUnit = $_g1[$_g];
				++$_g;
				if(Std::is($oUnit, _hx_qtype("mygame.game.entity.City")) && $oUnit->ability_get(_hx_qtype("mygame.game.ability.Position"))->tile_get() === $oTile) {
					$this->_oCache->get($s)->add($oTile);
				}
				unset($oUnit);
			}
		}
		return $this->_oCache->get($s);
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
	function __toString() { return 'mygame.game.query.CityTile'; }
}
