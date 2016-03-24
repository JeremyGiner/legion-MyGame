<?php

class utils_ListTool {
	public function __construct(){}
	static function merged_get($a1, $a2) {
		$a = new HList();
		if(null == $a1) throw new HException('null iterable');
		$__hx__it = $a1->iterator();
		while($__hx__it->hasNext()) {
			unset($oElem);
			$oElem = $__hx__it->next();
			$a->add($oElem);
		}
		if(null == $a2) throw new HException('null iterable');
		$__hx__it = $a2->iterator();
		while($__hx__it->hasNext()) {
			unset($oElem1);
			$oElem1 = $__hx__it->next();
			$a->add($oElem1);
		}
		return $a;
	}
	static function index_get($l, $o) {
		$i = 0;
		if(null == $l) throw new HException('null iterable');
		$__hx__it = $l->iterator();
		while($__hx__it->hasNext()) {
			unset($x);
			$x = $__hx__it->next();
			if(_hx_equal($x, $o)) {
				return $i;
			}
			$i++;
		}
		return -1;
	}
	function __toString() { return 'utils.ListTool'; }
}
