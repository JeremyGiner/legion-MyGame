<?php

class mygame_game_ability_Guidance extends mygame_game_ability_UnitAbility {
	public function __construct($oUnit) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oUnit);
		$this->_oMobility = $oUnit->ability_get(_hx_qtype("mygame.game.ability.Mobility"));
		if($this->_oMobility === null) {
			throw new HException("Guidance require mobility");
		}
		$this->_oVolume = $oUnit->ability_get(_hx_qtype("mygame.game.ability.Volume"));
		$this->_oPlan = $oUnit->ability_get(_hx_qtype("mygame.game.ability.PositionPlan"));
		$this->_oPathfinder = null;
		$this->_oGoal = null;
	}}
	public $_oMobility;
	public $_oVolume;
	public $_oPlan;
	public $_oPathfinder;
	public $_oGoal;
	public function goal_get() {
		return $this->_oGoal;
	}
	public function mobility_get() {
		return $this->_oMobility;
	}
	public function pathfinder_get() {
		return $this->_oPathfinder;
	}
	public function positionCorrection($oPoint) {
		if($this->_oMobility->plan_get() === null) {
			return $oPoint;
		}
		$oMap = $this->_oMobility->position_get()->map_get();
		$oVolume = $this->_oVolume;
		if($oVolume === null) {
			$oTile = $oMap->tile_get_byUnitMetric($oPoint->x, $oPoint->y);
			if($this->_oMobility->plan_get()->check($oTile)) {
				return $oPoint;
			}
			return null;
		} else {
			return $oVolume->positionCorrection($oPoint);
		}
		throw new HException("abnormal case");
		return null;
	}
	public function goal_set($oDestination) {
		$this->_oGoal = null;
		if($oDestination === null) {
			return;
		}
		$oTileDestination = $this->_oMobility->position_get()->map_get()->tile_get_byUnitMetric($oDestination->x, $oDestination->y);
		if(!$this->_oPlan->check($oTileDestination)) {
			haxe_Log::trace("[WARNING]:guidance:invalid destination tile", _hx_anonymous(array("fileName" => "Guidance.hx", "lineNumber" => 106, "className" => "mygame.game.ability.Guidance", "methodName" => "goal_set")));
			return;
		}
		$lDestination = new HList();
		$lDestination->add($oTileDestination);
		$lPosition = new HList();
		if($this->_oVolume === null) {
			$lPosition->push($this->_oMobility->position_get()->tile_get());
		} else {
			$lPosition = $this->_oVolume->tileList_get();
			$lPosition = utils_ListTool::merged_get($lPosition, $this->_oVolume->tileListProject_get($oDestination->x, $oDestination->y));
		}
		$this->_oPathfinder = new mygame_game_utils_PathFinderFlowField($this->_oMobility->position_get()->map_get(), $lDestination, $this->_oPlan);
		if(null == $lPosition) throw new HException('null iterable');
		$__hx__it = $lPosition->iterator();
		while($__hx__it->hasNext()) {
			unset($oTile);
			$oTile = $__hx__it->next();
			if($this->_oPathfinder->refTile_get($oTile) === null) {
				haxe_Log::trace("[ERROR]:Guidance:no path found.", _hx_anonymous(array("fileName" => "Guidance.hx", "lineNumber" => 137, "className" => "mygame.game.ability.Guidance", "methodName" => "goal_set")));
				return;
			}
		}
		$this->_oGoal = $oDestination->hclone();
		if($this->_oVolume !== null) {
			$this->_oGoal = $this->positionCorrection($this->_oGoal);
			if(null == $this->_oVolume->tileListProject_get($this->_oGoal->x, $this->_oGoal->y)) throw new HException('null iterable');
			$__hx__it = $this->_oVolume->tileListProject_get($this->_oGoal->x, $this->_oGoal->y)->iterator();
			while($__hx__it->hasNext()) {
				unset($oTile1);
				$oTile1 = $__hx__it->next();
				$this->_oPathfinder->refTile_set($oTile1, $oTile1);
			}
		}
	}
	public function process() {
		if($this->_oGoal !== null && $this->_oGoal->equal($this->_oMobility->position_get())) {
			$this->_oGoal = null;
		}
		if($this->_oGoal === null) {
			$this->_oMobility->force_set("Guidance", 0, 0, true);
			return;
		}
		$oVector = $this->_vector_get();
		$this->_oMobility->force_set("Guidance", $oVector->x, $oVector->y, true);
	}
	public function _vector_get() {
		$oTileOrigin = null;
		$oTileTargeted = null;
		if($this->_oVolume === null) {
			$oTilePosition = $this->_oMobility->position_get()->tile_get();
			$oTileTargeted = $this->_oPathfinder->refTile_get($oTilePosition);
			if($oTileTargeted === $oTilePosition) {
				return new space_Vector2i($this->_oGoal->x - $this->_oMobility->position_get()->x, $this->_oGoal->y - $this->_oMobility->position_get()->y);
			}
		} else {
			$lTile = $this->_oVolume->tileList_get();
			$b = true;
			if(null == $lTile) throw new HException('null iterable');
			$__hx__it = $lTile->iterator();
			while($__hx__it->hasNext()) {
				unset($oTile);
				$oTile = $__hx__it->next();
				if($oTile !== $this->_oPathfinder->refTile_get($oTile)) {
					$b = false;
					break;
				}
			}
			if($b) {
				return new space_Vector2i($this->_oGoal->x - $this->_oMobility->position_get()->x, $this->_oGoal->y - $this->_oMobility->position_get()->y);
			}
			{
				$_g = $lTile->length;
				switch($_g) {
				case 1:{
					$oTileTargeted = $this->_oPathfinder->refTile_get($lTile->first());
				}break;
				case 2:case 4:{
					if($this->_pathAssociated_check($this->_oPathfinder, $lTile)) {
						$heatBest = -1;
						$heatCurrent = null;
						if(null == $lTile) throw new HException('null iterable');
						$__hx__it = $lTile->iterator();
						while($__hx__it->hasNext()) {
							unset($oTile1);
							$oTile1 = $__hx__it->next();
							$heatCurrent = $this->_oPathfinder->heat_get_byTile($oTile1);
							if($heatCurrent > $heatBest) {
								$heatBest = $heatCurrent;
								$oTileOrigin = $oTile1;
							}
						}
						$oTileTargeted = $this->_oPathfinder->refTile_get($oTileOrigin);
					} else {
						$heatBest1 = 100000;
						$heatCurrent1 = null;
						if(null == $lTile) throw new HException('null iterable');
						$__hx__it = $lTile->iterator();
						while($__hx__it->hasNext()) {
							unset($oTile2);
							$oTile2 = $__hx__it->next();
							$heatCurrent1 = $this->_oPathfinder->heat_get_byTile($oTile2);
							if($heatCurrent1 < $heatBest1) {
								$heatBest1 = $heatCurrent1;
								$oTileTargeted = $oTile2;
							}
						}
					}
				}break;
				default:{
					throw new HException("what?! abnormal volume");
				}break;
				}
			}
		}
		if($oTileTargeted === null) {
			throw new HException("[ERROR]:pathfinder : wandering unit");
		}
		$oTileTargetedRef = $this->_oPathfinder->refTile_get($oTileTargeted);
		$v1 = new space_Vector2i($oTileTargeted->x_get() * 10000 + 5000 - $this->_oMobility->position_get()->x, $oTileTargeted->y_get() * 10000 + 5000 - $this->_oMobility->position_get()->y);
		$v2 = null;
		if($oTileTargeted === $oTileTargetedRef) {
			$v2 = new space_Vector2i($this->_oGoal->x - $this->_oMobility->position_get()->x, $this->_oGoal->y - $this->_oMobility->position_get()->y);
		} else {
			$v2 = new space_Vector2i($oTileTargetedRef->x_get() * 10000 + 5000 - $this->_oMobility->position_get()->x, $oTileTargetedRef->y_get() * 10000 + 5000 - $this->_oMobility->position_get()->y);
		}
		$fV2Length = $v2->length_get();
		$fProjMult = $v1->dotProduct($v2) / ($fV2Length * $fV2Length);
		$v3 = null;
		if($fProjMult > 0) {
			$v3 = $v2->hclone()->mult($fProjMult);
		} else {
			$v3 = $v2->hclone();
		}
		$v3->add($this->_oMobility->position_get()->x, $this->_oMobility->position_get()->y);
		if($oTileOrigin !== $oTileTargeted) {
			if($this->_oVolume === null) {
				$v3->set(utils_IntTool::max(utils_IntTool::min($v3->x, $oTileTargeted->x_get() * 10000 + 9999), $oTileTargeted->x_get() * 10000), utils_IntTool::max(utils_IntTool::min($v3->y, $oTileTargeted->y_get() * 10000 + 9999), $oTileTargeted->y_get() * 10000));
			} else {
				$fSize = $this->_oVolume->size_get();
				$v3->set(utils_IntTool::max(utils_IntTool::min($v3->x, $oTileTargeted->x_get() * 10000 + 9999 - $fSize), $oTileTargeted->x_get() * 10000 + $fSize), utils_IntTool::max(utils_IntTool::min($v3->y, $oTileTargeted->y_get() * 10000 + 9999 - $fSize), $oTileTargeted->y_get() * 10000 + $fSize));
			}
		}
		$v3->add(-$this->_oMobility->position_get()->x, -$this->_oMobility->position_get()->y);
		if(!Math::isFinite($v3->x) || !Math::isFinite($v3->y)) {
			throw new HException("[ERROR]:Guidance:invalide vector:" . Std::string($v3));
		}
		return $v3;
	}
	public function _pathAssociated_check($oPathfinder, $lTile) {
		$i = 0;
		if(null == $lTile) throw new HException('null iterable');
		$__hx__it = $lTile->iterator();
		while($__hx__it->hasNext()) {
			unset($oTile);
			$oTile = $__hx__it->next();
			$oTileRef = $oPathfinder->refTile_get($oTile);
			if(null == $lTile) throw new HException('null iterable');
			$__hx__it2 = $lTile->iterator();
			while($__hx__it2->hasNext()) {
				unset($oTileTmp);
				$oTileTmp = $__hx__it2->next();
				if($oTileTmp === $oTileRef) {
					$i++;
				}
				if($oPathfinder->refTile_get($oTileTmp) === $oTileRef) {
					$i++;
				}
			}
			unset($oTileRef);
		}
		return $i >= $lTile->length - 1;
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
	function __toString() { return 'mygame.game.ability.Guidance'; }
}
