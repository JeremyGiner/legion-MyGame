<?php

class mygame_game_ability_GuidancePlatoon extends mygame_game_ability_Guidance {
	public function __construct($oUnit) { if(!php_Boot::$skip_constructor) {
		parent::__construct($oUnit);
	}}
	public function goal_set($oDestination) {
		parent::goal_set($oDestination);
		if($this->_oGoal === null) {
			return;
		}
		$oPlatoon = $this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Platoon"));
		if($oPlatoon === null) {
			throw new HException("Error");
		}
		$oVolume = $this->_oUnit->ability_get(_hx_qtype("mygame.game.ability.Volume"));
		if($oVolume === null) {
			throw new HException("Error");
		}
		$aUnit = $oPlatoon->subUnit_get();
		{
			$_g1 = 0;
			$_g = $aUnit->length;
			while($_g1 < $_g) {
				$i = $_g1++;
				$oGuidance = _hx_array_get($aUnit, $i)->ability_get(_hx_qtype("mygame.game.ability.Guidance"));
				if($oGuidance === null) {
					continue;
				}
				$oOffset = $oPlatoon->offset_get($i);
				if($this->_oGoal !== null) {
					$oOffset = $oPlatoon->offset_get($i);
					$oOffset->mult($oVolume->size_get());
					$oOffset->vector_add($this->_oGoal);
					$oOffset->add(-$oVolume->size_get(), -$oVolume->size_get());
				}
				$oGuidance->goal_set($oOffset);
				unset($oOffset,$oGuidance,$i);
			}
		}
	}
	function __toString() { return 'mygame.game.ability.GuidancePlatoon'; }
}
