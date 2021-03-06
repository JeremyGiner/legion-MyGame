package websocket;

import websocket.Resource;

/**
 * Default distant socket factory
 * @author GINER Jérémy
 */
class SocketDistantFactory {

	var _oResource :Resource;
	
	public function new() {
		
	}
	
	public function resource_set( oResource :Resource ) {
		_oResource = oResource;
		return this;
	}
	
	public function create() :SocketDistant {
		return new SocketDistant( _oResource );
	}
}