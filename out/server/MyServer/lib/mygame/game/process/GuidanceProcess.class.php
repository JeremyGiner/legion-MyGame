<?php

class mygame_game_process_GuidanceProcess extends legion_BehaviourProcess {
	public function __construct($oGame) { if(!php_Boot::$skip_constructor) {
		parent::__construct($oGame);
	}}
	public function process() {
		if(null == $this->_mOption) throw new HException('null iterable');
		$__hx__it = $this->_mOption->iterator();
		while($__hx__it->hasNext()) {
			unset($oGuidance);
			$oGuidance = $__hx__it->next();
			$oGuidance->process();
		}
	}
	function __toString() { return 'mygame.game.process.GuidanceProcess'; }
}
