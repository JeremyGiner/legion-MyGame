<?php

class mygame_serverRemote_server_controller_Controller {
	public function __construct($mParam) {
		if(!php_Boot::$skip_constructor) {
		if($mParam->exists("start")) {
			$this->start();
			php_Lib::hprint("Started");
			Sys::hexit(0);
		} else {
			if($mParam->exists("log")) {
				php_Lib::hprint($this->log_get());
				Sys::hexit(0);
			}
		}
	}}
	public $_oProcess;
	public function start() {
		$_oProcess = new sys_io_Process("D:\\wamp\\bin\\php\\php5.4.12\\php.exe > C:\\mygame.log ", (new _hx_array(array("D:\\Workspace\\HaxeTest\\out\\server\\MyServer\\server.php"))));
	}
	public function log_get() {
		$fin = sys_io_File::read("C:\\mygame.log", false);
		$s = "";
		try {
			$s .= "file content:";
			$lineNum = 0;
			while(true) {
				$str = $fin->readLine();
				$s .= _hx_string_or_null($str) . "<br>";
				unset($str);
			}
		}catch(Exception $__hx__e) {
			$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
			if(($ex = $_ex_) instanceof haxe_io_Eof){} else throw $__hx__e;;
		}
		$fin->close();
		return $s;
	}
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->__dynamics[$m]) && is_callable($this->__dynamics[$m]))
			return call_user_func_array($this->__dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call <'.$m.'>');
	}
	function __toString() { return 'mygame.serverRemote.server.controller.Controller'; }
}
