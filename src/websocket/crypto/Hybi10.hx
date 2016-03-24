package websocket.crypto;

import haxe.crypto.Sha1;
import websocket.WSMessage;
//import haxe.crypto.Base64;


class Hybi10 {

	public static function encode( 
		sPayload :String,
		bMasked :Bool = false 
	):String {
		//untyped __php__("require_once(__DIR__.'/Hybi10.todo.php')");
		//return untyped __call__('todo\\Hybi10TMP::encode', sPayload, 'text', bMasked );
		
		//TODO : debug case length >= 9270
/*
	 |BYTE 1 --------|BYTE 2 --------|
      0                   1                   2                   3
      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
     +-+-+-+-+-------+-+-------------+-------------------------------+
     |F|R|R|R| opcode|M| Payload len |    Extended payload length    |
     |I|S|S|S|  (4)  |A|     (7)     |             (16/64)           |
     |N|V|V|V|       |S|             |   (if payload len==126/127)   |
     | |1|2|3|       |K|             |                               |
     +-+-+-+-+-------+-+-------------+ - - - - - - - - - - - - - - - +
     |     Extended payload length continued, if payload len == 127  |
     + - - - - - - - - - - - - - - - +-------------------------------+
     |                               |Masking-key, if MASK set to 1  |
     +-------------------------------+-------------------------------+
     | Masking-key (continued)       |          Payload Data         |
     +-------------------------------- - - - - - - - - - - - - - - - +
     :                     Payload Data continued ...                :
     + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +
     |                     Payload Data continued ...                |
     +---------------------------------------------------------------+
*/
		if ( bMasked )
			throw('Mask not implemented yet.');
		
		// Parameters
		var sType = 'text';
		var bContinuous = false;
		//___
		// Get OPCode
		var b1 :Int = 0;
		switch ( sType ) {
			case 'continuous':
				b1 = 0;	//Not supported
			case 'text':
				b1 = 1;
			case 'binary':
				b1 = 2;
			case 'close':
				b1 = 8;
			case 'ping':
				b1 = 9;
			case 'pong':
				b1 = 10;
			default :
				trace('Uknown opcode');
		}
		if ( bContinuous ) {
			//$user->sendingContinuous = true;
		} else {
			b1 += 128;	//FIN bit = true mean final fragment
			//$user->sendingContinuous = false;
		}
		
		var iLength = sPayload.length;
		
		var b2 = 0;
		var sLengthField = "";
		if ( iLength < 126) {
			// Between 0-125 (7 bits)
			b2 = iLength;
		} else {
			if ( iLength <= 65536 ) {
				// Between 126-65536 (7+16 bits)
				b2 = 126;	//1111110
				
				sLengthField = String.fromCharCode( (iLength & 0xFF00) >> 8 ) + String.fromCharCode( iLength & 0x00FF );
			} else {
				
				trace( 'fat load : '+ iLength );
				// Between 65536-?? 0xFFFF-0xFFFFFFFF (7+64 bits) ( Haxe limit to 32 bits)
				b2 = 127;	//1111111
				
				// Padding 8 byte compensate haxe limitation to 32bits
				for ( i in 0...4 )
					sLengthField += String.fromCharCode(0);
					
				// 32 bit lenght
				sLengthField += String.fromCharCode( (iLength & 0xFF000000) >> 3*8 );
				sLengthField += String.fromCharCode( (iLength & 0x00FF0000) >> 2*8 );
				sLengthField += String.fromCharCode( (iLength & 0x0000FF00) >> 8 );
				sLengthField += String.fromCharCode( (iLength & 0x000000FF) );
				//TODO test it
				
				trace('WARNING: untested functionnality');
			}
		}
		
		return String.fromCharCode(b1) + String.fromCharCode(b2) + sLengthField + sPayload;
	}
	
	public static function decode( sData :String ):WSMessage {
	
/*
	 |BYTE 1 --------|BYTE 2 --------|
      0                   1                   2                   3
      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
     +-+-+-+-+-------+-+-------------+-------------------------------+
     |F|R|R|R| opcode|M| Payload len |    Extended payload length    |
     |I|S|S|S|  (4)  |A|     (7)     |             (16/64)           |
     |N|V|V|V|       |S|             |   (if payload len==126/127)   |
     | |1|2|3|       |K|             |                               |
     +-+-+-+-+-------+-+-------------+ - - - - - - - - - - - - - - - +
     |     Extended payload length continued, if payload len == 127  |
     + - - - - - - - - - - - - - - - +-------------------------------+
     |                               |Masking-key, if MASK set to 1  |
     +-------------------------------+-------------------------------+
     | Masking-key (continued)       |          Payload Data         |
     +-------------------------------- - - - - - - - - - - - - - - - +
     :                     Payload Data continued ...                :
     + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +
     |                     Payload Data continued ...                |
     +---------------------------------------------------------------+
*/
		// Get opcode
		var iOpCode = sData.charCodeAt(0)&0x0F;
		
		// Get payload length
		var iPayloadLength = sData.charCodeAt(1)&0x7F;
		
		
		var bMaskEnabled = (sData.charCodeAt(1)&0x80 != 0);
		
		var iPayloadOffset :Int = null;
		var sMask = null;
		if ( iPayloadLength == 126 ) {
			sMask = sData.substr(4,4);
			iPayloadOffset = 8;
		} else if( iPayloadLength == 127 ) {
			sMask = sData.substr(10,4);
			iPayloadOffset = 14;
		} else {
			sMask = sData.substr(2,4);
			iPayloadOffset = 6;
		}
		
		
		var sPayload :String = null;
		if ( bMaskEnabled == true ) {
			sPayload = '';
			for ( i in iPayloadOffset...sData.length) {
				var j = i - iPayloadOffset;
				sPayload += String.fromCharCode( sData.charCodeAt(i) ^ sMask.charCodeAt(j %4) );
			}
		} else {
			iPayloadOffset -= 4;
			sPayload = sData.substr( iPayloadOffset );
		}
		
		return new WSMessage( iOpCode, sPayload );
	}

//______________________________________________________________________________

	public static function handshake_get( sClientHandshake :String ) {
	
		var sWSProtocol :String = '';
		
		// Get key and accept from client's header
			var oRegExp :EReg = ~/Sec-WebSocket-Key: (.*)\r\n/;
			oRegExp.match( sClientHandshake );
			var sKey :String ='';
			sKey = oRegExp.matched( 1 );
			
			var sWSAccept :String = accept_get( sKey );
			//sWSAccept = Socket.handshakeHBI10Accept_get( 'dGhlIHNhbXBsZSBub25jZQ==' );
		
		// Compose response
			var sResponse :String = '';
			sResponse +=
				"HTTP/1.1 101 Switching Protocols\r\n"+
				"Upgrade: WebSocket\r\n"+
				"Connection: Upgrade\r\n"+
				"Sec-WebSocket-Accept: " + sWSAccept + "\r\n";
			if( sWSProtocol != '')
				sResponse += "Sec-WebSocket-Protocol: TODONameMyApply\r\n";
			sResponse += "\r\n";
		
		return sResponse;
	}
	
//______________________________________________________________________________
//	Utils

	private static function accept_get( sKey :String ) {
		return untyped __call__('base64_encode',
			untyped __call__(
				'pack',
				'H*', 
				Sha1.encode( sKey + '258EAFA5-E914-47DA-95CA-C5AB0DC85B11')
			)
		);
	}
}