<?php

interface haxe_IMap {
	function get($k);
	function set($k, $v);
	function keys();
	function iterator();
}
