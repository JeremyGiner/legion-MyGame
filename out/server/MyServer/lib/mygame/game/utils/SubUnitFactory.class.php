<?php

class mygame_game_utils_SubUnitFactory {
	public function __construct() {}
	public function _create($sClassName, $oGame, $oPlayer, $oPosition, $oPlatoon) { if(!php_Boot::$skip_constructor) {
		return Type::createInstance(Type::resolveClass($sClassName), (new _hx_array(array($oGame, $oPlayer, $oPosition, $oPlatoon))));
	}}
	static function STcreate($sClassName, $oGame, $oPlayer, $oPosition, $oPlatoon) {
		$o = new mygame_game_utils_SubUnitFactory();
		return $o->_create($sClassName, $oGame, $oPlayer, $oPosition, $oPlatoon);
	}
	function __toString() { return 'mygame.game.utils.SubUnitFactory'; }
}
