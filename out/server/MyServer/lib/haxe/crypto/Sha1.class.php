<?php

class haxe_crypto_Sha1 {
	public function __construct(){}
	static function encode($s) {
		return sha1($s);
	}
	function __toString() { return 'haxe.crypto.Sha1'; }
}
