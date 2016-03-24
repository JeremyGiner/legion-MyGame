package websocket;
/**
 * Group of messages
 * @author GINER Jérémy
 */
class MessageComposite implements IMessage {
	public var _aMessage :Array<IMessage>;
	
	public function new( aMessage :Array<IMessage> ) {
		_aMessage = aMessage;
	}
	
	public function componentArray_get() {
		return _aMessage;
	}
}