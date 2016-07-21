<?php

interface legion_IProcessBehaviour extends legion_IProcess{
	function add($oEntity, $oOption);
	function remove($oEntity);
	function hasEntity($oEntity);
	function option_get($oEntity);
}
