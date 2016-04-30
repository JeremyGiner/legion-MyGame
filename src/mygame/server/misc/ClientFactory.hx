package mygame.server.misc;
import mygame.server.model.Client;
import websocket.SocketDistant;
import websocket.SocketDistantFactory;

/**
 * ...
 * @author GINER Jérémy
 */
class ClientFactory extends SocketDistantFactory {

	public function new() {
		super();
	}
	
	override public function create() :SocketDistant {
		return new Client( _oResource );
	}
	
}