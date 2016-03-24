<?php

class utils_Disposer {
	public function __construct() {}
	static function dispose($o) { if(!php_Boot::$skip_constructor) {
		if($o === null) {
			throw new HException("[ERROR]:Disposer:dispose:o is null.");
		}
		{
			$_g = 0;
			$_g1 = Reflect::fields($o);
			while($_g < $_g1->length) {
				$oField = $_g1[$_g];
				++$_g;
				$o->{$oField} = null;
				unset($oField);
			}
		}
	}}
	function __toString() { return 'utils.Disposer'; }
}
