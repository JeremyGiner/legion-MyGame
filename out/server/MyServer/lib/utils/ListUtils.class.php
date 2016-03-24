<?php

class utils_ListUtils {
	public function __construct(){}
	static function index_get($l, $o) {
		$i = 0;
		if(null == $l) throw new HException('null iterable');
		$__hx__it = $l->iterator();
		while($__hx__it->hasNext()) {
			$x = $__hx__it->next();
			if(_hx_equal($x, $o)) {
				return $i;
			}
			$i++;
		}
		return -1;
	}
	static function hclone($l) {
		$lClone = new HList();
		if(null == $l) throw new HException('null iterable');
		$__hx__it = $l->iterator();
		while($__hx__it->hasNext()) {
			$x = $__hx__it->next();
			$lClone->add($x);
		}
		return $lClone;
	}
	function __toString() { return 'utils.ListUtils'; }
}
