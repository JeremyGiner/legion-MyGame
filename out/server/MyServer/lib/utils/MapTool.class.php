<?php

class utils_MapTool {
	public function __construct(){}
	static function getMergedIntMap($oMap1, $oMap2) {
		$oMap = new haxe_ds_IntMap();
		if(null == $oMap1) throw new HException('null iterable');
		$__hx__it = $oMap1->keys();
		while($__hx__it->hasNext()) {
			unset($oKey);
			$oKey = $__hx__it->next();
			$oMap->set($oKey, $oMap1->get($oKey));
		}
		if(null == $oMap2) throw new HException('null iterable');
		$__hx__it = $oMap2->keys();
		while($__hx__it->hasNext()) {
			unset($oKey1);
			$oKey1 = $__hx__it->next();
			$oMap->set($oKey1, $oMap2->get($oKey1));
		}
		return $oMap;
	}
	static function getLength($oMap) {
		$i = 0;
		if(null == $oMap) throw new HException('null iterable');
		$__hx__it = $oMap->iterator();
		while($__hx__it->hasNext()) {
			unset($e);
			$e = $__hx__it->next();
			$i++;
		}
		return $i;
	}
	static function toList($oMap) {
		$l = new HList();
		if(null == $oMap) throw new HException('null iterable');
		$__hx__it = $oMap->iterator();
		while($__hx__it->hasNext()) {
			unset($e);
			$e = $__hx__it->next();
			$l->add($e);
		}
		return $l;
	}
	function __toString() { return 'utils.MapTool'; }
}
