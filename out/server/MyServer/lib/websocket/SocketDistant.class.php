<?php

class websocket_SocketDistant extends websocket_Socket {
	public function __construct($oResource) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($oResource);
		$this->_bHandshaked = false;
		$this->_sInBuffer = "";
		$this->onMessage = new trigger_eventdispatcher_EventDispatcher();
		$this->onClose = new trigger_eventdispatcher_EventDispatcher();
	}}
	public $_bHandshaked;
	public $_sInBuffer;
	public $onMessage;
	public function isHandshaked_get() {
		return $this->_bHandshaked;
	}
	public function process() {
		$iLength = 4096;
		if($this->closed_check() === true) {
			return;
		}
		$this->_sInBuffer = "";
		$iByteN = @socket_recv($this->_oResource, $this->_sInBuffer, $iLength, 0);
		if(_hx_equal($iByteN, false)) {
			$error = socket_last_error($this->_oResource);
			if($error !== 0) {
				haxe_Log::trace("[ERROR]:socket error:" . _hx_string_or_null(socket_strerror($error)), _hx_anonymous(array("fileName" => "SocketDistant.hx", "lineNumber" => 62, "className" => "websocket.SocketDistant", "methodName" => "process")));
			}
			return;
		}
		if($iByteN === 0) {
			return;
		}
		if(strlen($this->_sInBuffer) === 0) {
			haxe_Log::trace("[WARNING]:did not close proper way", _hx_anonymous(array("fileName" => "SocketDistant.hx", "lineNumber" => 72, "className" => "websocket.SocketDistant", "methodName" => "process")));
			$this->_close();
			return;
		}
		if(!$this->isHandshaked_get()) {
			$this->_handshake($this->_sInBuffer);
			return;
		}
		$oMessage = websocket_crypto_Hybi10::decode($this->_sInBuffer);
		$this->_sInBuffer = $oMessage->payload_get();
		if($oMessage->opcode_get() === 8) {
			$this->_close();
			return;
		}
		$this->_message_handle();
	}
	public function _handshake($sHandshake) {
		$this->write(websocket_crypto_Hybi10::handshake_get($sHandshake));
		$this->_bHandshaked = true;
	}
	public function _message_handle() {
		haxe_Log::trace("[NOTICE]:SocketDistant:message receive : " . _hx_string_or_null($this->_sInBuffer), _hx_anonymous(array("fileName" => "SocketDistant.hx", "lineNumber" => 104, "className" => "websocket.SocketDistant", "methodName" => "_message_handle")));
		$this->onMessage->dispatch($this);
	}
	public function write($sBuffer) {
		$sOutBuffer = $sBuffer;
		if($this->isHandshaked_get()) {
			$sOutBuffer = websocket_crypto_Hybi10::encode($sOutBuffer, null);
		}
		return socket_write($this->_oResource, $sOutBuffer, strlen($sOutBuffer));
	}
	public function readResult_get() {
		return $this->_sInBuffer;
	}
	public function handshake($sHandshake) {
		$this->_handshake($sHandshake);
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
	function __toString() { return 'websocket.SocketDistant'; }
}
