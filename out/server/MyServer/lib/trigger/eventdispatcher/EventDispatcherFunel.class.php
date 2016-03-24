<?php

class trigger_eventdispatcher_EventDispatcherFunel extends trigger_EventDispatcher2 implements trigger_ITrigger, trigger_IEventDispatcher{
	public function __construct() { if(!php_Boot::$skip_constructor) {
		parent::__construct();
	}}
	public function link_add($oIEventDispatcher) {
		$oIEventDispatcher->remove($this);
		return $this;
	}
	public function link_remove($oIEventDispatcher) {
		$oIEventDispatcher->remove($this);
		return $this;
	}
	public function trigger($oSource) {
		$this->dispatch($oSource->event_get());
	}
	function __toString() { return 'trigger.eventdispatcher.EventDispatcherFunel'; }
}
