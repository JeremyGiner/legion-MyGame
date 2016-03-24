<?php

interface IMap {
	function keys();
	function set($k, $v);
	function get($k);
}
