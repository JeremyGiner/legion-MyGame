<?php

class mygame_game_tile_Tile {
	public function __construct($oMap, $x, $y, $z, $iType) {
		if(!php_Boot::$skip_constructor) {
		$this->_x = $x;
		$this->_y = $y;
		$this->_z = $z;
		$this->_iType = $iType;
		$this->_oMap = $oMap;
	}}
	public $_oMap;
	public $_x;
	public $_y;
	public $_z;
	public $_iType;
	public function x_get() {
		return $this->_x;
	}
	public function y_get() {
		return $this->_y;
	}
	public function z_get() {
		return $this->_z;
	}
	public function type_get() {
		return $this->_iType;
	}
	public function map_get() {
		return $this->_oMap;
	}
	public function neighborList_get() {
		$loTile = new HList();
		$oTile = null;
		{
			$_g = 0;
			while($_g < 4) {
				$i = $_g++;
				switch($i) {
				case 0:{
					$oTile = $this->_oMap->tile_get($this->x_get() + 1, $this->y_get());
				}break;
				case 1:{
					$oTile = $this->_oMap->tile_get($this->x_get() - 1, $this->y_get());
				}break;
				case 2:{
					$oTile = $this->_oMap->tile_get($this->x_get(), $this->y_get() + 1);
				}break;
				case 3:{
					$oTile = $this->_oMap->tile_get($this->x_get(), $this->y_get() - 1);
				}break;
				}
				if($oTile !== null) {
					$loTile->push($oTile);
				}
				unset($i);
			}
		}
		return $loTile;
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
	static function tileGeometry_get($oTile) {
		return new space_AlignedAxisBoxAlti(9999, 9999, new space_Vector2i($oTile->x_get() * 10000, $oTile->y_get() * 10000));
	}
	function __toString() { return 'mygame.game.tile.Tile'; }
}
