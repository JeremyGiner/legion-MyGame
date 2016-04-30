<?php

class mygame_game_ability_Mobility extends mygame_game_ability_UnitAbility {
	public function __construct($oUnit, $fSpeed) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oUnit);
		$this->_oPosition = $oUnit->ability_get(_hx_qtype("mygame.game.ability.Position"));
		$this->_oPlan = $oUnit->ability_get(_hx_qtype("mygame.game.ability.PositionPlan"));
		$this->_oVolume = $oUnit->ability_get(_hx_qtype("mygame.game.ability.Volume"));
		if($this->_oPosition === null) {
			haxe_Log::trace("[ERROR]:Mobility require Positione ability.", _hx_anonymous(array("fileName" => "Mobility.hx", "lineNumber" => 50, "className" => "mygame.game.ability.Mobility", "methodName" => "new")));
		}
		$this->_fSpeed = $fSpeed;
		$this->_oVelocity = new space_Vector2i(0, 0);
		$this->_fOrientation = 0;
		$this->_fOrientationSpeed = 0.4;
		$this->_moForce = new haxe_ds_StringMap();
	}}
	public $_oPosition;
	public $_oPlan;
	public $_oVolume;
	public $_fSpeed;
	public $_oVelocity;
	public $_moForce;
	public $_fOrientation;
	public $_fOrientationSpeed;
	public $_oGoalTile;
	public function position_get() {
		return $this->_oPosition;
	}
	public function plan_get() {
		return $this->_oPlan;
	}
	public function orientation_get() {
		return $this->_fOrientation;
	}
	public function force_get($sKey) {
		return $this->_moForce->get($sKey);
	}
	public function speed_set($fSpeed) {
		$this->_fSpeed = $fSpeed;
	}
	public function orientationSpeed_set($fOrientationSpeed) {
		$this->_fOrientationSpeed = $fOrientationSpeed;
	}
	public function force_set($sKey, $fX, $fY, $bSpeedLimit = null) {
		if($bSpeedLimit === null) {
			$bSpeedLimit = true;
		}
		$this->_moForce->set($sKey, _hx_anonymous(array("oVector" => new space_Vector2i($fX, $fY), "bLimit" => $bSpeedLimit)));
	}
	public function direction_set($oVector) {
		$v = $oVector->hclone();
		$v->length_set($this->_fSpeed);
		$this->_oVelocity->set($v->x, $v->y);
	}
	public function move() {
		$this->_oVelocity->set(0, 0);
		if(null == $this->_moForce) throw new HException('null iterable');
		$__hx__it = $this->_moForce->iterator();
		while($__hx__it->hasNext()) {
			unset($oForce);
			$oForce = $__hx__it->next();
			$oVector = $oForce->oVector->hclone();
			if($oForce->bLimit && $oVector->length_get() > $this->_fSpeed) {
				$oVector->length_set($this->_fSpeed);
			}
			$this->_oVelocity->add($oVector->x, $oVector->y);
			unset($oVector);
		}
		if($this->_oVelocity->x === 0 && $this->_oVelocity->y === 0) {
			return;
		}
		$oVectorOrientation = null;
		if($this->_moForce->get("Guidance") !== null) {
			$oVectorOrientation = $this->_moForce->get("Guidance")->oVector->hclone();
			$this->_orientation_update($oVectorOrientation);
		}
		$this->_collision_process();
		$this->_position_set($this->_oVelocity->x + $this->_oPosition->x, $this->_oVelocity->y + $this->_oPosition->y);
	}
	public function clampAngle($a) {
		$b = $a;
		while($b >= Math::$PI * 2) {
			$b -= Math::$PI * 2;
		}
		while($b < 0) {
			$b += Math::$PI * 2;
		}
		$b = _hx_mod($b, Math::$PI * 2);
		return $b;
	}
	public function _position_set($fPositionX, $fPositionY) {
		$this->_oPosition->set($fPositionX, $fPositionY);
	}
	public function _orientation_update($oDirection) {
		if($oDirection === null) {
			return;
		}
		$fGoal = $oDirection->angleAxisXY();
		if($fGoal === null) {
			return;
		}
		$fGoal = $this->clampAngle($fGoal);
		if($this->_fOrientation !== $fGoal) {
			$fDelta = $fGoal - $this->_fOrientation;
			if(_hx_equal($fDelta, 0)) {
				$this->_fOrientation = $fGoal;
			} else {
				$fDirection = 0;
				if($fDelta > Math::$PI) {
					$fDelta -= Math::$PI * 2;
				}
				if($fDelta > 0) {
					$fDirection = 1;
				} else {
					$fDirection = -1;
				}
				$this->_fOrientation += $fDirection * Math::min(Math::abs($fDelta), $this->_fOrientationSpeed);
			}
			$this->_fOrientation = _hx_mod($this->_fOrientation, Math::$PI * 2);
		}
	}
	public function _collision_process() {
		if($this->_oPlan === null) {
			return true;
		}
		$oGeometry = null;
		$aX = (new _hx_array(array($this->_oPosition->x)));
		$aY = (new _hx_array(array($this->_oPosition->y)));
		if($this->_oVolume === null) {
			$oGeometry = $this->_oPosition;
			$aX->push($this->_oPosition->x - $this->_oVelocity->x);
			$aX->push($this->_oPosition->x + $this->_oVelocity->x);
			$aY->push($this->_oPosition->y - $this->_oVelocity->y);
			$aY->push($this->_oPosition->y + $this->_oVelocity->y);
		} else {
			$oGeometry = $this->_oVolume->geometry_get();
			$aX->push($oGeometry->right_get() - $this->_oVelocity->x);
			$aX->push($oGeometry->right_get() + $this->_oVelocity->x);
			$aX->push($oGeometry->left_get() - $this->_oVelocity->x);
			$aX->push($oGeometry->left_get() + $this->_oVelocity->x);
			$aY->push($oGeometry->bottom_get() - $this->_oVelocity->y);
			$aY->push($oGeometry->bottom_get() + $this->_oVelocity->y);
			$aY->push($oGeometry->top_get() - $this->_oVelocity->y);
			$aY->push($oGeometry->top_get() + $this->_oVelocity->y);
		}
		$xMin = $aX[0];
		$xMax = $aX[0];
		{
			$_g = 0;
			while($_g < $aX->length) {
				$f = $aX[$_g];
				++$_g;
				$xMax = utils_IntTool::max($xMax, $f);
				$xMin = utils_IntTool::min($xMin, $f);
				unset($f);
			}
		}
		$yMin = $aY[0];
		$yMax = $aY[0];
		{
			$_g1 = 0;
			while($_g1 < $aY->length) {
				$f1 = $aY[$_g1];
				++$_g1;
				$yMax = utils_IntTool::max($yMax, $f1);
				$yMin = utils_IntTool::min($yMin, $f1);
				unset($f1);
			}
		}
		$loTile = $this->_oPosition->map_get()->tileList_get_byArea(mygame_game_ability_Position::metric_unit_to_maptile($xMin), mygame_game_ability_Position::metric_unit_to_maptile($xMax), mygame_game_ability_Position::metric_unit_to_maptile($yMin), mygame_game_ability_Position::metric_unit_to_maptile($yMax));
		$loTmp = new HList();
		if(null == $loTile) throw new HException('null iterable');
		$__hx__it = $loTile->iterator();
		while($__hx__it->hasNext()) {
			unset($oTile);
			$oTile = $__hx__it->next();
			if(!$this->_oPlan->check($oTile)) {
				$loTmp->push($oTile);
			}
		}
		$loTile = $loTmp;
		$oCollisionMin = null;
		$oTileMin = null;
		if(null == $loTile) throw new HException('null iterable');
		$__hx__it = $loTile->iterator();
		while($__hx__it->hasNext()) {
			unset($oTile1);
			$oTile1 = $__hx__it->next();
			$oCollision = collider_CollisionCheckerPriorInt::check($oGeometry, $this->_oVelocity, mygame_game_ability_Mobility::tileGeometry_get($oTile1), null);
			if($oCollision !== null) {
				if($oCollisionMin === null) {
					$oCollisionMin = $oCollision;
					$oTileMin = $oTile1;
				} else {
					if($oCollision->time_get() < $oCollisionMin->time_get()) {
						$oCollisionMin = $oCollision;
						$oTileMin = $oTile1;
					}
				}
			}
			unset($oCollision);
		}
		if($oCollisionMin !== null && $oCollisionMin->time_get() <= 1 && $oCollisionMin->time_get() >= 0) {
			$this->_collision_correct($oCollisionMin);
			return false;
		}
		return true;
	}
	public function _collision_correct($oCollisionEvent) {
		$fTime = $oCollisionEvent->time_get();
		$fTimeBefore = $fTime;
		$oVector = $oCollisionEvent->velocityA_get();
		if($oVector->x === 0 && $oVector->y === 0) {
			throw new HException("[ERROR]:_collision_correct:Invalid vector");
		}
		$i = 1;
		do {
			$fPres = Math::abs(Math::min(mygame_game_ability_Mobility_0($this, $fTime, $fTimeBefore, $i, $oCollisionEvent, $oVector), mygame_game_ability_Mobility_1($this, $fTime, $fTimeBefore, $i, $oCollisionEvent, $oVector)));
			$fTimeBefore = $fTime - $fPres * $i;
			$oVector->mult($fTimeBefore);
			$i++;
			unset($fPres);
		} while(collider_CollisionCheckerPriorInt::check($oCollisionEvent->shapeA_get(), $oCollisionEvent->velocityA_get(), $oCollisionEvent->shapeB_get(), $oCollisionEvent->VelocityB_get()) !== null && $i !== 100);
		if($i === 100) {
			throw new HException("[ERROR]:_collision_correct:failed after 100 of attempt");
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
	static function tileGeometry_get($oTile) {
		return new space_AlignedAxisBoxAlti(9999, 9999, new space_Vector2i($oTile->x_get() * 10000, $oTile->y_get() * 10000));
	}
	function __toString() { return 'mygame.game.ability.Mobility'; }
}
function mygame_game_ability_Mobility_0(&$__hx__this, &$fTime, &$fTimeBefore, &$i, &$oCollisionEvent, &$oVector) {
	if($oVector->x === 0) {
		return 1000000;
	} else {
		return 1 / $oVector->x;
	}
}
function mygame_game_ability_Mobility_1(&$__hx__this, &$fTime, &$fTimeBefore, &$i, &$oCollisionEvent, &$oVector) {
	if($oVector->y === 0) {
		return 1000000;
	} else {
		return 1 / $oVector->y;
	}
}
