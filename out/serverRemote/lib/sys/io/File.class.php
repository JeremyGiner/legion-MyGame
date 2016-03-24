<?php

class sys_io_File {
	public function __construct(){}
	static function read($path, $binary = null) {
		if($binary === null) {
			$binary = true;
		}
		return new sys_io_FileInput(fopen($path, (($binary) ? "rb" : "r")));
	}
	function __toString() { return 'sys.io.File'; }
}
