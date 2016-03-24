<?php

class StringTools {
	public function __construct(){}
	static function hex($n, $digits = null) {
		$s = dechex($n); $len = 8;
		if(strlen($s) > (StringTools_0($digits, $len, $n, $s))) {
			$s = _hx_substr($s, -$len, null);
		} else {
			if($digits !== null) {
				$s = ((strlen("0") === 0 || strlen($s) >= $digits) ? $s : str_pad($s, Math::ceil(($digits - strlen($s)) / strlen("0")) * strlen("0") + strlen($s), "0", STR_PAD_LEFT));
			}
		}
		return strtoupper($s);
	}
	function __toString() { return 'StringTools'; }
}
function StringTools_0(&$digits, &$len, &$n, &$s) {
	if(null === $digits) {
		return $len;
	} else {
		return $len = (($digits > $len) ? $digits : $len);
	}
}
