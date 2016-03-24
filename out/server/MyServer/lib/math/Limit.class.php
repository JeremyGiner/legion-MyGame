<?php

class math_Limit {
	public function __construct(){}
	static $fSmallest = 2.22507385850720e-308;
	static $fLargest = 1.79769313486232e+308;
	function __toString() { return 'math.Limit'; }
}
