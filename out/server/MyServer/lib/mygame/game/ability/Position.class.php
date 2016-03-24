<?php

class mygame_game_ability_Position extends space_Vector2i implements legion_ability_IAbility{
	public function __construct($oUnit, $oWorldMap, $x_, $y_) {
		if(!php_Boot::$skip_constructor) {
		$this->_oUnit = $oUnit;
		$this->_oWorldMap = $oWorldMap;
		parent::__construct($x_,$y_);
	}}
	public $_oWorldMap;
	public $_oUnit;
	public $_oTile;
	public function set($x_, $y_ = null) {
		if($y_ === null) {
			$y_ = 0;
		}
		$this->x = $x_;
		$this->y = $y_;
		$this->_oTile = $this->_oWorldMap->tile_get_byUnitMetric($this->x, $this->y);
		return $this;
	}
	public function tile_get() {
		return $this->_oTile;
	}
	public function map_get() {
		return $this->_oWorldMap;
	}
	public function dispose() {}
	public function unit_get() {
		return $this->_oUnit;
	}
	public function mainClassName_get() {
		return Type::getClassName(Type::getClass($this));
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
	static function metric_unit_to_maptile($i) {
		return Math::floor($i / 10000);
	}
	static function metric_unit_to_map($i) {
		return $i / 10000;
	}
	static function metric_unit_to_map_vector($oVector) {
		return new space_Vector3($oVector->x / 10000, $oVector->y / 10000, null);
	}
	static function metric_map_to_unit($i) {
		return $i * 10000;
	}
	static function metric_map_to_unit_vector($oVector) {
		return new space_Vector2i(Math::round($oVector->x * 10000), Math::round($oVector->y * 10000));
	}
	function __toString() { return 'mygame.game.ability.Position'; }
}
