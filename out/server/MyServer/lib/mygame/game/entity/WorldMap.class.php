<?php

class mygame_game_entity_WorldMap extends legion_entity_Entity {
	public function __construct($oGame) {
		if(!php_Boot::$skip_constructor) {
		$this->_iSizeY = 10;
		$this->_iSizeX = 10;
		parent::__construct($oGame);
	}}
	public $_iSizeX;
	public $_iSizeY;
	public $_aoTile;
	public function sizeX_get() {
		return $this->_iSizeX;
	}
	public function sizeY_get() {
		return $this->_iSizeY;
	}
	public function tile_get($x, $y) {
		if($x < 0 || $y < 0 || $x >= $this->_iSizeX || $y >= $this->_iSizeY) {
			return null;
		}
		return $this->_aoTile[$x][$y];
	}
	public function tile_get_byVector($oPosition) {
		return $this->tile_get(Math::floor($oPosition->x), Math::floor($oPosition->y));
	}
	public function tile_get_byUnitMetric($x, $y) {
		return $this->tile_get(Math::floor($x / 10000), Math::floor($y / 10000));
	}
	public function tileList_gather($oParent) {
		$loTile = new HList();
		$loTile->add($oParent);
		$oTile = null;
		{
			$_g = 0;
			while($_g < 8) {
				$i = $_g++;
				switch($i) {
				case 0:{
					$oTile = $this->tile_get($oParent->x_get() + 1, $oParent->y_get());
				}break;
				case 1:{
					$oTile = $this->tile_get($oParent->x_get() + 1, $oParent->y_get() + 1);
				}break;
				case 2:{
					$oTile = $this->tile_get($oParent->x_get(), $oParent->y_get() + 1);
				}break;
				case 3:{
					$oTile = $this->tile_get($oParent->x_get() - 1, $oParent->y_get() + 1);
				}break;
				case 4:{
					$oTile = $this->tile_get($oParent->x_get() - 1, $oParent->y_get());
				}break;
				case 5:{
					$oTile = $this->tile_get($oParent->x_get() - 1, $oParent->y_get() - 1);
				}break;
				case 6:{
					$oTile = $this->tile_get($oParent->x_get(), $oParent->y_get() - 1);
				}break;
				case 7:{
					$oTile = $this->tile_get($oParent->x_get() + 1, $oParent->y_get() - 1);
				}break;
				}
				if($oTile !== null) {
					$loTile->add($oTile);
				}
				unset($i);
			}
		}
		return $loTile;
	}
	public function tileList_get_byArea($xMin, $xMax, $yMin, $yMax) {
		$loTile = new HList();
		$oTile = null;
		{
			$_g1 = $xMin;
			$_g = $xMax + 1;
			while($_g1 < $_g) {
				$x = $_g1++;
				{
					$_g3 = $yMin;
					$_g2 = $yMax + 1;
					while($_g3 < $_g2) {
						$y = $_g3++;
						$oTile = $this->tile_get($x, $y);
						if($oTile !== null) {
							$loTile->add($oTile);
						}
						unset($y);
					}
					unset($_g3,$_g2);
				}
				unset($x);
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
	static $TILETYPE_SEA = 0;
	static $TILETYPE_GRASS = 1;
	static $TILETYPE_FOREST = 2;
	static $TILETYPE_MOUNTAIN = 3;
	static $TILETYPE_ROAD = 4;
	static function load($oData, $oGame) {
		$oWorldMapTmp = new mygame_game_entity_WorldMap($oGame);
		$oWorldMapTmp->_iSizeX = $oData->iSizeX;
		$oWorldMapTmp->_iSizeY = $oData->iSizeY;
		$oWorldMapTmp->_aoTile = new _hx_array(array());
		{
			$_g1 = 0;
			$_g = $oWorldMapTmp->_iSizeX;
			while($_g1 < $_g) {
				$i = $_g1++;
				$oWorldMapTmp->_aoTile[$i] = new _hx_array(array());
				{
					$_g3 = 0;
					$_g2 = $oWorldMapTmp->_iSizeY;
					while($_g3 < $_g2) {
						$j = $_g3++;
						{
							$_g4 = $oData->aoTile[$j][$i];
							switch($_g4) {
							case 0:{
								$oWorldMapTmp->_aoTile[$i][$j] = new mygame_game_tile_Sea($oWorldMapTmp, $i, $j);
							}break;
							case 1:{
								$oWorldMapTmp->_aoTile[$i][$j] = new mygame_game_tile_Grass($oWorldMapTmp, $i, $j);
							}break;
							case 2:{
								$oWorldMapTmp->_aoTile[$i][$j] = new mygame_game_tile_Forest($oWorldMapTmp, $i, $j);
							}break;
							case 3:{
								$oWorldMapTmp->_aoTile[$i][$j] = new mygame_game_tile_Mountain($oWorldMapTmp, $i, $j);
							}break;
							case 4:{
								$oWorldMapTmp->_aoTile[$i][$j] = new mygame_game_tile_Road($oWorldMapTmp, $i, $j);
							}break;
							}
							unset($_g4);
						}
						unset($j);
					}
					unset($_g3,$_g2);
				}
				unset($i);
			}
		}
		mygame_game_entity_WorldMap::mirrorY($oWorldMapTmp);
		return $oWorldMapTmp;
	}
	static function mirrorY($oWorldMap) {
		{
			$_g1 = 0;
			$_g = $oWorldMap->_iSizeX;
			while($_g1 < $_g) {
				$i = $_g1++;
				{
					$_g3 = 0;
					$_g2 = $oWorldMap->_iSizeY;
					while($_g3 < $_g2) {
						$j = $_g3++;
						$oTile = $oWorldMap->_aoTile[$i][$j];
						$iSize = $oWorldMap->sizeY_get() * 2 - 1;
						$oWorldMap->_aoTile[$i][$iSize - $j] = new mygame_game_tile_Tile($oWorldMap, $i, $iSize - $j, $oTile->z_get(), $oTile->type_get());
						unset($oTile,$j,$iSize);
					}
					unset($_g3,$_g2);
				}
				unset($i);
			}
		}
		$oWorldMap->_iSizeY *= 2;
	}
	function __toString() { return 'mygame.game.entity.WorldMap'; }
}
