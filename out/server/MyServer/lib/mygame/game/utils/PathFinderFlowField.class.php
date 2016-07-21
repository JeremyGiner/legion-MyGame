<?php

class mygame_game_utils_PathFinderFlowField {
	public function __construct($oWorldMap, $lDestination, $pTest) {
		if(!php_Boot::$skip_constructor) {
		$this->_oWorldMap = $oWorldMap;
		$this->_aReferenceMap = new haxe_ds_StringMap();
		$this->_aHeatMap = new haxe_ds_StringMap();
		$this->_lTileCurrent = new HList();
		$this->_pTest = $pTest;
		if(null == $lDestination) throw new HException('null iterable');
		$__hx__it = $lDestination->iterator();
		while($__hx__it->hasNext()) {
			unset($oTile);
			$oTile = $__hx__it->next();
			$this->_aReferenceMap->set($this->_key_get($oTile), $oTile);
			$this->_aHeatMap->set($this->_key_get($oTile), 0);
			$this->_lTileCurrent->push($oTile);
		}
	}}
	public $_oWorldMap;
	public $_aHeatMap;
	public $_aReferenceMap;
	public $_lTileCurrent;
	public $_pTest;
	public function worldmap_get() {
		return $this->_oWorldMap;
	}
	public function refTile_getbyCoord($x, $y) {
		if($this->_aReferenceMap === null) {
			return null;
		}
		return $this->_aReferenceMap->get(_hx_string_rec($x, "") . ";" . _hx_string_rec($y, ""));
	}
	public function refTile_get($oTile) {
		if($this->_aReferenceMap === null) {
			return null;
		}
		$this->_update($oTile);
		return $this->_aReferenceMap->get($this->_key_get($oTile));
	}
	public function heat_get_byTile($oTile) {
		if($oTile === null) {
			return 1073741823;
		}
		$this->_update($oTile);
		return $this->_aHeatMap->get($this->_key_get($oTile));
	}
	public function refTile_set($oTile, $oTileRef) {
		if($this->_aReferenceMap->get($this->_key_get($oTile)) === null) {
			throw new HException("nasty");
		}
		$this->_aReferenceMap->set($this->_key_get($oTile), $oTileRef);
	}
	public function _update($oTile) {
		if($this->_aReferenceMap->exists($this->_key_get($oTile))) {
			return;
		}
		$l = new HList();
		$l->add($oTile);
		$this->_referenceMap_update($l);
	}
	public function _key_get($oTile) {
		return _hx_string_rec($oTile->x_get(), "") . ";" . _hx_string_rec($oTile->y_get(), "");
	}
	public function _referenceMap_update($lTileStart) {
		$lTileStartRemaining = utils_ListTool::merged_get($lTileStart, new HList());
		$oTileParent = null;
		$oTileChild = null;
		while(!$this->_lTileCurrent->isEmpty()) {
			$oTileParent = $this->_lTileCurrent->pop();
			{
				$_g = 0;
				$_g1 = $this->_tileChild_get($oTileParent);
				while($_g < $_g1->length) {
					$oTileChild1 = $_g1[$_g];
					++$_g;
					if($oTileChild1 !== null && Std::is($oTileChild1, _hx_qtype("mygame.game.tile.Tile"))) {
						if($this->_pTest->validate($oTileChild1)) {
							if($this->_aReferenceMap->get($this->_key_get($oTileChild1)) === null) {
								$this->_aReferenceMap->set($this->_key_get($oTileChild1), $oTileParent);
								$this->_aHeatMap->set($this->_key_get($oTileChild1), $this->_aHeatMap->get($this->_key_get($oTileParent)) + 1);
								$this->_lTileCurrent->add($oTileChild1);
							} else {
								$oPrevRef = $this->refTile_get($oTileChild1);
								$oNewRef = $oTileParent;
								if($this->heat_get($oNewRef) > $this->heat_get($oPrevRef)) {
									continue;
								}
								$oPrevRefRef = $this->refTile_get($oPrevRef);
								$oNewRefRef = $this->refTile_get($oNewRef);
								$v = $this->_line_intersect($oNewRef->x_get(), $oNewRef->y_get(), $oNewRefRef->x_get(), $oNewRefRef->y_get(), $oPrevRef->x_get(), $oPrevRef->y_get(), $oPrevRefRef->x_get(), $oPrevRefRef->y_get());
								if($v === null) {
									continue;
								}
								$oVectorTmp = new space_Vector3($v->x - $oNewRef->x_get(), $v->y - $oNewRef->y_get(), null);
								if($oVectorTmp->dotProduct(new space_Vector3($oNewRefRef->x_get() - $oNewRef->x_get(), $oNewRefRef->y_get() - $oNewRef->y_get(), null)) < 0) {
									continue;
								}
								$t = $this->_oWorldMap->tile_get(Math::floor($v->x), Math::floor($v->y));
								if($t === null || !$this->_pTest->validate($t) || $t === $oTileChild1) {
									continue;
									throw new HException("NOT OK");
									throw new HException("NOT OK");
								}
								$this->_aReferenceMap->set($this->_key_get($oTileChild1), $t);
								unset($v,$t,$oVectorTmp,$oPrevRefRef,$oPrevRef,$oNewRefRef,$oNewRef);
							}
						}
					}
					unset($oTileChild1);
				}
				unset($_g1,$_g);
			}
			while($lTileStartRemaining->remove($oTileParent)) {
			}
			if($lTileStartRemaining->isEmpty()) {
				return true;
			}
		}
		haxe_Log::trace("[ERROR] : Pathfinder : no PATH found\x0A", _hx_anonymous(array("fileName" => "PathFinderFlowField.hx", "lineNumber" => 234, "className" => "mygame.game.utils.PathFinderFlowField", "methodName" => "_referenceMap_update")));
		return false;
	}
	public function _tileChild_get($oTileParent) {
		return _hx_deref((new _hx_array(array($this->_oWorldMap->tile_get($oTileParent->x_get() + 1, $oTileParent->y_get()), $this->_oWorldMap->tile_get($oTileParent->x_get() - 1, $oTileParent->y_get()), $this->_oWorldMap->tile_get($oTileParent->x_get(), $oTileParent->y_get() + 1), $this->_oWorldMap->tile_get($oTileParent->x_get(), $oTileParent->y_get() - 1)))))->filter(array(new _hx_lambda(array(&$oTileParent), "mygame_game_utils_PathFinderFlowField_0"), 'execute'));
	}
	public function heat_get($oTile) {
		return $this->_aHeatMap->get($this->_key_get($oTile));
	}
	public function refMapDiff_get($x, $y) {
		$v = new space_Vector3(null, null, null);
		$v->x = $this->_aReferenceMap->get(_hx_string_rec($x, "") . ";" . _hx_string_rec($y, ""))->x_get() - $x;
		$v->y = $this->_aReferenceMap->get(_hx_string_rec($x, "") . ";" . _hx_string_rec($y, ""))->y_get() - $y;
		return $v;
	}
	public function _line_intersect($x1, $y1, $x2, $y2, $x3, $y3, $x4, $y4) {
		$a = $x1 * $y2 - $y1 * $x2;
		$dX34 = $x3 - $x4;
		$dX12 = $x1 - $x2;
		$d = $x3 * $y4 - $y3 * $x4;
		$dy34 = $y3 - $y4;
		$dy12 = $y1 - $y2;
		$g = $dX12 * $dy34 - $dy12 * $dX34;
		if($g === 0) {
			return null;
		}
		$v = new space_Vector3(null, null, null);
		$v->x = ($a * $dX34 - $dX12 * $d) / $g;
		$v->y = ($a * $dy34 - $dy12 * $d) / $g;
		return $v;
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
	function __toString() { return 'mygame.game.utils.PathFinderFlowField'; }
}
function mygame_game_utils_PathFinderFlowField_0(&$oTileParent, $oTile) {
	{
		return $oTile !== null;
	}
}
