<?php

class websocket_crypto_Hybi10 {
	public function __construct(){}
	static function encode($sPayload, $bMasked = null) {
		if($bMasked === null) {
			$bMasked = false;
		}
		if($bMasked) {
			throw new HException("Mask not implemented yet.");
		}
		$sType = "text";
		$bContinuous = false;
		$b1 = 0;
		switch($sType) {
		case "continuous":{
			$b1 = 0;
		}break;
		case "text":{
			$b1 = 1;
		}break;
		case "binary":{
			$b1 = 2;
		}break;
		case "close":{
			$b1 = 8;
		}break;
		case "ping":{
			$b1 = 9;
		}break;
		case "pong":{
			$b1 = 10;
		}break;
		default:{
			haxe_Log::trace("Uknown opcode", _hx_anonymous(array("fileName" => "Hybi10.hx", "lineNumber" => 62, "className" => "websocket.crypto.Hybi10", "methodName" => "encode")));
		}break;
		}
		if($bContinuous) {} else {
			$b1 += 128;
		}
		$iLength = strlen($sPayload);
		$b2 = 0;
		$sLengthField = "";
		if($iLength < 126) {
			$b2 = $iLength;
		} else {
			if($iLength <= 65536) {
				$b2 = 126;
				$sLengthField = _hx_string_or_null(chr(($iLength & 65280) >> 8)) . _hx_string_or_null(chr($iLength & 255));
			} else {
				haxe_Log::trace("fat load : " . _hx_string_rec($iLength, ""), _hx_anonymous(array("fileName" => "Hybi10.hx", "lineNumber" => 86, "className" => "websocket.crypto.Hybi10", "methodName" => "encode")));
				$b2 = 127;
				{
					$_g = 0;
					while($_g < 4) {
						$i = $_g++;
						$sLengthField .= _hx_string_or_null(chr(0));
						unset($i);
					}
				}
				$sLengthField .= _hx_string_or_null(chr(($iLength & -16777216) >> 24));
				$sLengthField .= _hx_string_or_null(chr(($iLength & 16711680) >> 16));
				$sLengthField .= _hx_string_or_null(chr(($iLength & 65280) >> 8));
				$sLengthField .= _hx_string_or_null(chr($iLength & 255));
				haxe_Log::trace("WARNING: untested functionnality", _hx_anonymous(array("fileName" => "Hybi10.hx", "lineNumber" => 101, "className" => "websocket.crypto.Hybi10", "methodName" => "encode")));
			}
		}
		return _hx_string_or_null(chr($b1)) . _hx_string_or_null(chr($b2)) . _hx_string_or_null($sLengthField) . _hx_string_or_null($sPayload);
	}
	static function decode($sData) {
		$iOpCode = _hx_char_code_at($sData, 0) & 15;
		$iPayloadLength = _hx_char_code_at($sData, 1) & 127;
		$bMaskEnabled = (_hx_char_code_at($sData, 1) & 128) !== 0;
		$iPayloadOffset = null;
		$sMask = null;
		if($iPayloadLength === 126) {
			$sMask = _hx_substr($sData, 4, 4);
			$iPayloadOffset = 8;
		} else {
			if($iPayloadLength === 127) {
				$sMask = _hx_substr($sData, 10, 4);
				$iPayloadOffset = 14;
			} else {
				$sMask = _hx_substr($sData, 2, 4);
				$iPayloadOffset = 6;
			}
		}
		$sPayload = null;
		if($bMaskEnabled === true) {
			$sPayload = "";
			{
				$_g1 = $iPayloadOffset;
				$_g = strlen($sData);
				while($_g1 < $_g) {
					$i = $_g1++;
					$j = $i - $iPayloadOffset;
					$sPayload .= _hx_string_or_null(chr(_hx_char_code_at($sData, $i) ^ _hx_char_code_at($sMask, _hx_mod($j, 4))));
					unset($j,$i);
				}
			}
		} else {
			$iPayloadOffset -= 4;
			$sPayload = _hx_substr($sData, $iPayloadOffset, null);
		}
		return new websocket_WSMessage($iOpCode, $sPayload);
	}
	static function handshake_get($sClientHandshake) {
		$sWSProtocol = "";
		$oRegExp = new EReg("Sec-WebSocket-Key: (.*)\x0D\x0A", "");
		$oRegExp->match($sClientHandshake);
		$sKey = "";
		$sKey = $oRegExp->matched(1);
		$sWSAccept = websocket_crypto_Hybi10::accept_get($sKey);
		$sResponse = "";
		$sResponse .= "HTTP/1.1 101 Switching Protocols\x0D\x0A" . "Upgrade: WebSocket\x0D\x0A" . "Connection: Upgrade\x0D\x0A" . "Sec-WebSocket-Accept: " . _hx_string_or_null($sWSAccept) . "\x0D\x0A";
		if($sWSProtocol !== "") {
			$sResponse .= "Sec-WebSocket-Protocol: TODONameMyApply\x0D\x0A";
		}
		$sResponse .= "\x0D\x0A";
		return $sResponse;
	}
	static function accept_get($sKey) {
		return base64_encode(pack("H*", haxe_crypto_Sha1::encode(_hx_string_or_null($sKey) . "258EAFA5-E914-47DA-95CA-C5AB0DC85B11")));
	}
	function __toString() { return 'websocket.crypto.Hybi10'; }
}
