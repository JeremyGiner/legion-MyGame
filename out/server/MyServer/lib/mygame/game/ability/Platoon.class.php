<?php

class mygame_game_ability_Platoon extends mygame_game_ability_Guidance {
	public function __construct($oUnit, $oPosition) {
		if(!php_Boot::$skip_constructor) {
		$this->_iUnitQ = 20;
		$this->_iVolume = 4000;
		$this->_aSubUnit = new _hx_array(array());
		{
			$_g1 = 0;
			$_g = $this->_iUnitQ;
			while($_g1 < $_g) {
				$i = $_g1++;
				$this->_aSubUnit->push(new mygame_game_entity_SubUnit($oUnit, $this->offset_get($oPosition, $i)));
				unset($i);
			}
		}
		parent::__construct($this->_aSubUnit[0]);
		$this->_oUnit = $oUnit;
	}}
	public $_aSubUnit;
	public $_iUnitQ;
	public $_iVolume;
	public $_iPitch;
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
	public function offset_get($oPosition, $iKey) {
		$iPitch = Math::ceil(Math::sqrt($this->_iUnitQ));
		return new space_Vector2i($oPosition->x + _hx_mod($iKey, $iPitch) * $this->positionPading_get() - Math::floor($this->_iVolume / 2), $oPosition->y + Math::floor($iKey / $iPitch) * $this->positionPading_get() - Math::floor($this->_iVolume / 2));
	}
	public function positionPading_get() {
		return Math::floor($this->_iVolume / (Math::ceil(Math::sqrt($this->_iUnitQ)) - 1));
	}
	public function halfSize_get() {
		return Math::ceil($this->_iVolume / 2);
	}
	public function tileListProject_get($x, $y) {
		$iHalfSize = $this->_iVolume / 2;
		$loTile = $this->unit_get()->mygame_get()->map_get()->tileList_get_byArea(Math::floor(($x - $iHalfSize) / 10000), Math::floor(($x + $iHalfSize) / 10000), Math::floor(($y - $iHalfSize) / 10000), Math::floor(($y + $iHalfSize) / 10000));
		return $loTile;
	}
	public function positionCorrection($oPoint) {
		$oPlan = $this->_oMobility->plan_get();
		if($oPlan === null) {
			return $oPoint;
		}
		$oMap = $this->_oMobility->position_get()->map_get();
		$lTile = $this->tileListProject_get($oPoint->x, $oPoint->y);
		$oResult = $oPoint->hclone();
		$_iHalfSize = $this->halfSize_get();
		$oUnitGeometry = new space_AlignedAxisBox2i($_iHalfSize, $_iHalfSize, $oPoint);
		$oTileGeometry = null;
		if(null == $lTile) throw new HException('null iterable');
		$__hx__it = $lTile->iterator();
		while($__hx__it->hasNext()) {
			unset($oTile);
			$oTile = $__hx__it->next();
			if($oPlan->check($oTile)) {
				continue;
			}
			$oTileGeometry = mygame_game_tile_Tile::tileGeometry_get($oTile);
			if(!collider_CollisionCheckerPostInt::check($oUnitGeometry, $oTileGeometry)) {
				continue;
			}
			$iVolumeSize = $_iHalfSize;
			$dx = $oPoint->x / 10000 - ($oTile->x_get() + 0.5);
			$dy = $oPoint->y / 10000 - ($oTile->y_get() + 0.5);
			if(Math::abs($dx) > Math::abs($dy)) {
				if($dx > 0) {
					$oResult->x = $oTileGeometry->right_get() + 1 + $iVolumeSize;
				} else {
					$oResult->x = $oTileGeometry->left_get() - 1 - $iVolumeSize;
				}
			} else {
				if($dy > 0) {
					$oResult->y = $oTileGeometry->top_get() + 1 + $iVolumeSize;
				} else {
					$oResult->y = $oTileGeometry->bottom_get() - 1 - $iVolumeSize;
				}
			}
			unset($iVolumeSize,$dy,$dx);
		}
		return $oResult;
		throw new HException("abnormal case");
		return null;
	}
	public function goal_set($oDestination) {
		if($oDestination === null) {
			$this->_oGoal = null;
			return;
		}
		$this->_oGoal = $oDestination->hclone();
		if($this->_oGoal === null) {
			return;
		}
		$aUnit = $this->subUnit_get();
		{
			$_g1 = 0;
			$_g = $aUnit->length;
			while($_g1 < $_g) {
				$i = $_g1++;
				$oGuidance = _hx_array_get($aUnit, $i)->ability_get(_hx_qtype("mygame.game.ability.Guidance"));
				if($oGuidance === null) {
					throw new HException("Expected a guidance");
				}
				$oOffset = $this->offset_get($this->_oGoal, $i);
				$oGuidance->goal_set($oOffset);
				unset($oOffset,$oGuidance,$i);
			}
		}
	}
	public function process() {}
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
