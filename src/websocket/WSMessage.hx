package websocket;

/**
 * ...
 * @author GINER Jérémy
 */
class WSMessage {
	/**
	 * 
     |Opcode  | Meaning                             | Reference |
    -+--------+-------------------------------------+-----------|
     | 0      | Continuation Frame                  | RFC 6455  |
    -+--------+-------------------------------------+-----------|
     | 1      | Text Frame                          | RFC 6455  |
    -+--------+-------------------------------------+-----------|
     | 2      | Binary Frame                        | RFC 6455  |
    -+--------+-------------------------------------+-----------|
     | 8      | Connection Close Frame              | RFC 6455  |
    -+--------+-------------------------------------+-----------|
     | 9      | Ping Frame                          | RFC 6455  |
    -+--------+-------------------------------------+-----------|
     | 10     | Pong Frame                          | RFC 6455  |
    -+--------+-------------------------------------+-----------|
	 */
	var _iOpCode :Int;
	var _sPayload :String;

	public function new( iOpCode :Int, sPayload ) {
		_iOpCode = iOpCode;
		_sPayload = sPayload;
	}
	
	public function opcode_get() {
		return _iOpCode;
	}
	
	public function payload_get() {
		return _sPayload;
	}
	
}