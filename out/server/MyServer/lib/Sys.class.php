<?php

class Sys {
	public function __construct(){}
	static function hexit($code) {
		exit($code);
	}
	function __toString() { return 'Sys'; }
}
