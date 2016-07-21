<?php

class mygame_game_utils_validatorentity_ValiEntityInArray implements utils_IValidator{
	public function __construct($oEntity) {
		if(!php_Boot::$skip_constructor) {
		$this->_oReference = $oEntity;
	}}
	public $_oReference;
	public function validate($aEntity) {
		{
			$_g = 0;
			while($_g < $aEntity->length) {
				$oEntity = $aEntity[$_g];
				++$_g;
				if($oEntity === $this->_oReference) {
					return true;
				}
				unset($oEntity);
			}
		}
		return false;
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
	function __toString() { return 'mygame.game.utils.validatorentity.ValiEntityInArray'; }
}
