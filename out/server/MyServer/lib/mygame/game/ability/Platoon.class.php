<?php

class mygame_game_ability_Platoon extends mygame_game_ability_EntityAbility {
	public function __construct($oCommander) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oCommander);
		$this->_iUnitQ = 20;
		$this->_iVolume = 8000;
		$this->_fDirection = Math::$PI / 4;
		$oPosition = $oCommander->ability_get(_hx_qtype("mygame.game.ability.Position"));
		$oPlayer = $oCommander->ability_get(_hx_qtype("mygame.game.ability.Loyalty"))->owner_get();
		$this->_aSubUnit = (new _hx_array(array($oCommander)));
		$sClassName = Type::getClassName(Type::getClass($this->entity_get()));
		{
			$_g1 = 0;
			$_g = $this->_iUnitQ - 1;
			while($_g1 < $_g) {
				$i = $_g1++;
				$this->_aSubUnit->push(mygame_game_utils_SubUnitFactory::STcreate($sClassName, $oCommander->game_get(), $oPlayer, $this->offset_get($oPosition, $i, $this->_fDirection), $this));
				unset($i);
			}
		}
		{
			$_g2 = 0;
			$_g11 = $this->_aSubUnit;
			while($_g2 < $_g11->length) {
				$oSubUnit = $_g11[$_g2];
				++$_g2;
				if($oCommander === $oSubUnit) {
					continue;
				}
				$this->entity_get()->game_get()->entity_add($oSubUnit);
				unset($oSubUnit);
			}
		}
	}}
	public $_aSubUnit;
	public $_iUnitQ;
	public $_iVolume;
	public $_fDirection;
	public $_iPitch;
	public function entity_get() {
		return $this->commander_get();
	}
	public function commander_get() {
		return _hx_array_get($this->subUnit_get(), 0);
	}
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
	public function offset_get($oPosition, $iKey, $fAngle) {
		if($oPosition === null) {
			return null;
		}
		$fAngle += Math::$PI / 2;
		$iPitch = Math::ceil(Math::sqrt($this->_iUnitQ));
		$fOffsetCenter = Math::floor($this->_iVolume / 2);
		$fOffsetX = $iKey / $this->_iUnitQ * $this->_iVolume - $fOffsetCenter;
		$fOffsetY = 0;
		$fCos = Math::cos($fAngle);
		$fSin = Math::sin($fAngle);
		return new space_Vector2i(Math::round($oPosition->x + $fOffsetX * $fCos - $fOffsetY * $fSin), Math::round($oPosition->y + $fOffsetY * $fCos + $fOffsetX * $fSin));
	}
	public function positionPading_get() {
		return Math::floor($this->_iVolume / (Math::ceil(Math::sqrt($this->_iUnitQ)) - 1));
	}
	public function halfSize_get() {
		return Math::ceil($this->_iVolume / 2);
	}
	public function unitQuantityMax_get() {
		return $this->_iUnitQ;
	}
	public function tileListProject_get($x, $y) {
		$iHalfSize = $this->_iVolume / 2;
		$loTile = $this->commander_get()->game_get()->map_get()->tileList_get_byArea(Math::floor(($x - $iHalfSize) / 10000), Math::floor(($x + $iHalfSize) / 10000), Math::floor(($y - $iHalfSize) / 10000), Math::floor(($y + $iHalfSize) / 10000));
		return $loTile;
	}
	public function positionCorrection($oPoint) {
		$oPlan = $this->commander_get()->ability_get(_hx_qtype("mygame.game.ability.PositionPlan"));
		if($oPlan === null) {
			return $oPoint;
		}
		$oMap = $this->commander_get()->ability_get(_hx_qtype("mygame.game.ability.Position"))->map_get();
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
			if($oPlan->validate($oTile)) {
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
	public function waypoint_set($oDestination, $fAngle) {
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
				$oOffset = $this->offset_get($oDestination, $i, $fAngle);
				$oGuidance->waypoint_set($oOffset);
				unset($oOffset,$oGuidance,$i);
			}
		}
	}
	public function waypoint_add($oDestination, $fAngle) {
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
				$oOffset = $this->offset_get($oDestination, $i, $fAngle);
				$oGuidance->waypoint_add($oOffset);
				unset($oOffset,$oGuidance,$i);
			}
		}
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
