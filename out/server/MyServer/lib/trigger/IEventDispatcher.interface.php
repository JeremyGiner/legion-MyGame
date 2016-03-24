<?php

interface trigger_IEventDispatcher {
	function attach($oTrigger);
	function remove($oTrigger);
	function event_get();
}
