<?php

class utils_IntTool {
	public function __construct(){}
	static $MAX = 1073741823;
	static function min($a, $b) {
		if($a > $b) {
			return $b;
		}
		return $a;
	}
	static function max($a, $b) {
		if($a < $b) {
			return $b;
		}
		return $a;
	}
	static function abs($a) {
		if($a < 0) {
			return -$a;
		}
		return $a;
	}
	function __toString() { return 'utils.IntTool'; }
}
