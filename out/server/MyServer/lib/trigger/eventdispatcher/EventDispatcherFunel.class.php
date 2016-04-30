<?php

class trigger_eventdispatcher_EventDispatcherFunel extends trigger_EventDispatcher2 implements trigger_ITrigger, trigger_IEventDispatcher{
	public function __construct() { if(!php_Boot::$skip_constructor) {
		parent::__construct();
	}}
	public function trigger($oSource) {
		$this->dispatch($oSource->event_get());
	}
	function __toString() { return 'trigger.eventdispatcher.EventDispatcherFunel'; }
}
