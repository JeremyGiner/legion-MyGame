<?php

class mygame_game_ability_Volume extends mygame_game_ability_UnitAbility {
	public function __construct($oUnit, $fHalfSize = null, $fWeight = null) {
		if(!php_Boot::$skip_constructor) {
		if($fWeight === null) {
			$fWeight = 1;
		}
		if($fHalfSize === null) {
			$fHalfSize = 2000;
		}
		parent::__construct($oUnit);
		$this->_oPosition = $oUnit->ability_get(_hx_qtype("mygame.game.ability.Position"));
		if($this->_oPosition === null) {
			haxe_Log::trace("[ERROR]:ability dependency not respected.", _hx_anonymous(array("fileName" => "Volume.hx", "lineNumber" => 33, "className" => "mygame.game.ability.Volume", "methodName" => "new")));
		}
		$this->_fWeight = $fWeight;
		$this->_iHalfSize = $fHalfSize;
		if($this->_iHalfSize < 0 || $this->_iHalfSize >= 5000) {
			throw new HException("invalid volume size.");
		}
		$this->_oHitBox = new space_AlignedAxisBox2i($this->_iHalfSize, $this->_iHalfSize, $this->_oPosition);
		$this->_oVelocity = null;
	}}
	public $_oPosition;
	public $_iHalfSize;
	public $_fWeight;
	public $_oHitBox;
	public $_oVelocity;
	public function position_get() {
		return $this->_oPosition;
	}
	public function size_get() {
		return $this->_iHalfSize;
	}
	public function weight_get() {
		return $this->_fWeight;
	}
	public function geometry_get() {
		return $this->_oHitBox;
	}
	public function tileArray_get() {
		$loTile = $this->_oPosition->map_get()->tileList_get_byArea(Math::floor($this->_oHitBox->left_get() / 10000), Math::floor($this->_oHitBox->right_get() / 10000), Math::floor($this->_oHitBox->bottom_get() / 10000), Math::floor($this->_oHitBox->top_get() / 10000));
		return $loTile;
	}
	public function tileList_get() {
		$loTile = $this->_oPosition->map_get()->tileList_get_byArea(Math::floor($this->_oHitBox->left_get() / 10000), Math::floor($this->_oHitBox->right_get() / 10000), Math::floor($this->_oHitBox->bottom_get() / 10000), Math::floor($this->_oHitBox->top_get() / 10000));
		return $loTile;
	}
	public function tileListProject_get($x, $y) {
		$oHitBox = new space_AlignedAxisBox2i($this->_oHitBox->halfWidth_get(), $this->_oHitBox->halfHeight_get(), new space_Vector2i($x, $y));
		$loTile = $this->_oPosition->map_get()->tileList_get_byArea(Math::floor($oHitBox->left_get() / 10000), Math::floor($oHitBox->right_get() / 10000), Math::floor($oHitBox->bottom_get() / 10000), Math::floor($oHitBox->top_get() / 10000));
		return $loTile;
	}
	public function positionCorrection($oPoint) {
		$lTile = $this->tileListProject_get($oPoint->x, $oPoint->y);
		$oResult = $oPoint->hclone();
		$oUnitGeometry = new space_AlignedAxisBox2i($this->size_get(), $this->size_get(), $oPoint);
		$oTileGeometry = null;
		if(null == $lTile) throw new HException('null iterable');
		$__hx__it = $lTile->iterator();
		while($__hx__it->hasNext()) {
			unset($oTile);
			$oTile = $__hx__it->next();
			if($this->unit_get()->ability_get(_hx_qtype("mygame.game.ability.PositionPlan"))->check($oTile)) {
				continue;
			}
			$oTileGeometry = mygame_game_tile_Tile::tileGeometry_get($oTile);
			if(!collider_CollisionCheckerPostInt::check($oUnitGeometry, $oTileGeometry)) {
				continue;
			}
			$iVolumeSize = $this->size_get();
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
	function __toString() { return 'mygame.game.ability.Volume'; }
}
