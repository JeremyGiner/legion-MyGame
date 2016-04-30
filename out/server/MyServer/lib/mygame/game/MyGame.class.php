<?php

class mygame_game_MyGame extends legion_Game {
	public function __construct($oConf) {
		if(!php_Boot::$skip_constructor) {
		$this->_oMap = null;
		$this->_iLoop = 0;
		parent::__construct();
		$this->onLoop = new trigger_eventdispatcher_EventDispatcher();
		$this->onLoopEnd = new trigger_eventdispatcher_EventDispatcher();
		$this->onHealthAnyUpdate = new trigger_EventDispatcher2();
		$this->onLoyaltyAnyUpdate = new trigger_eventdispatcher_EventDispatcherFunel();
		$this->onPositionAnyUpdate = new trigger_eventdispatcher_EventDispatcherFunel();
		$this->_aoHero = new _hx_array(array());
		$this->_aoPlayer = new _hx_array(array());
		$this->_oPositionDistance = new mygame_game_misc_PositionDistance();
		$this->_oWinner = null;
		$this->_aAction = new haxe_ds_IntMap();
		$this->_singleton_add(new mygame_game_misc_weapon_WeaponTypeBazoo());
		$this->_singleton_add(new mygame_game_misc_weapon_WeaponTypeSoldier());
		$this->_singleton_add(new mygame_game_query_CityTile($this));
		$this->_singleton_add(new mygame_game_query_UnitDist($this));
		$this->_singleton_add(new mygame_game_query_UnitQuery($this));
		$this->_oMap = mygame_game_entity_WorldMap::load(_hx_anonymous(array("iSizeX" => $oConf->map->sizeX, "iSizeY" => $oConf->map->sizeY, "aoTile" => $oConf->map->tileArr)), $this);
		{
			$_g = 0;
			$_g1 = $oConf->playerArr;
			while($_g < $_g1->length) {
				$oConfPlayer = $_g1[$_g];
				++$_g;
				$this->player_add(new mygame_game_entity_Player($this, $oConfPlayer->name));
				unset($oConfPlayer);
			}
		}
		$this->entity_add($this->_oMap);
		$this->entity_add(new mygame_game_entity_City($this, null, $this->_oMap->tile_get(2, 6)));
		$this->entity_add(new mygame_game_entity_City($this, null, $this->_oMap->tile_get(2, 13)));
		$this->entity_add(new mygame_game_entity_City($this, null, $this->_oMap->tile_get(9, 1)));
		$this->entity_add(new mygame_game_entity_City($this, null, $this->_oMap->tile_get(9, 18)));
		$this->entity_add(new mygame_game_entity_City($this, null, $this->_oMap->tile_get(13, 7)));
		$this->entity_add(new mygame_game_entity_City($this, null, $this->_oMap->tile_get(13, 12)));
		$this->entity_add(new mygame_game_entity_Factory($this, $this->player_get(0), $this->_oMap->tile_get(3, 2)));
		$this->entity_add(new mygame_game_entity_Factory($this, $this->player_get(1), $this->_oMap->tile_get(3, 17)));
		$this->_aoHero[0] = $this->_aoEntity[$this->_aoEntity->length - 1];
		$this->_aoHero[1] = $this->_aoEntity[$this->_aoEntity->length - 1];
		new mygame_game_process_VolumeEjection($this);
		new mygame_game_process_MobilityProcess($this);
		$this->oWeaponProcess = new mygame_game_process_WeaponProcess($this);
		new mygame_game_process_LoyaltyShiftProcess($this);
		new mygame_game_process_Death($this);
		new mygame_game_process_DeathPlatoon($this);
		$this->oVictoryCondition = new mygame_game_process_VictoryCondition($this);
	}}
	public $_iLoop;
	public $_oMap;
	public $_aoHero;
	public $_aoPlayer;
	public $_oWinner;
	public $_oPositionDistance;
	public $_aAction;
	public $onLoop;
	public $onLoopEnd;
	public $onHealthAnyUpdate;
	public $onLoyaltyAnyUpdate;
	public $onPositionAnyUpdate;
	public $oWeaponProcess;
	public $oVictoryCondition;
	public function loop() {
		$this->_iLoop++;
		$iTime = Date::now()->getTime();
		$this->onLoop->dispatch($this);
		$iTime = Date::now()->getTime();
		$this->onLoopEnd->dispatch($this);
	}
	public function log_get() {
		return $this->_aAction;
	}
	public function winner_get() {
		return $this->_oWinner;
	}
	public function map_get() {
		return $this->_oMap;
	}
	public function loopId_get() {
		return $this->_iLoop;
	}
	public function hero_get($oPlayer) {
		return $this->_aoHero[$oPlayer->playerId_get()];
	}
	public function action_run($oAction) {
		if(!$oAction->check($this)) {
			return false;
		}
		if($this->_aAction->get($this->_iLoop) === null) {
			$this->_aAction->set($this->_iLoop, new HList());
		}
		$this->_aAction->get($this->_iLoop)->add($oAction);
		$oAction->exec($this);
		return true;
	}
	public function entity_add($oEntity) {
		parent::entity_add($oEntity);
		$oPlatoon = $oEntity->ability_get(_hx_qtype("mygame.game.ability.Platoon"));
		if($oPlatoon !== null) {
			$aUnit = $oPlatoon->subUnit_get();
			{
				$_g = 0;
				while($_g < $aUnit->length) {
					$oSubUnit = $aUnit[$_g];
					++$_g;
					$this->entity_add($oSubUnit);
					unset($oSubUnit);
				}
			}
		}
	}
	public function entity_remove($oEntity) {
		parent::entity_remove($oEntity);
	}
	public function player_get($iKey) {
		return $this->_aoPlayer[$iKey];
	}
	public function player_get_all() {
		return $this->_aoPlayer;
	}
	public function positionDistance_get() {
		return $this->_oPositionDistance;
	}
	public function end($oWinner) {
		$this->_oWinner = $oWinner;
	}
	public function player_add($oPlayer) {
		$i = $this->_aoPlayer->length;
		$this->_aoPlayer[$i] = $oPlayer;
		$oPlayer->playerId_set($i);
		$this->entity_add($oPlayer);
		return $i;
	}
	public function save() {
		haxe_Serializer::$USE_CACHE = true;
		return haxe_Serializer::run($this);
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
	static function load($oGameState) {
		if(Std::is($oGameState, _hx_qtype("String"))) {
			return haxe_Unserializer::run($oGameState);
		}
		throw new HException("[ERROR] MyGame : load : can not resolve.");
		return null;
	}
	function __toString() { return 'mygame.game.MyGame'; }
}
