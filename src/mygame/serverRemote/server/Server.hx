package mygame.serverRemote.server;
import mygame.serverRemote.server.controller.Controller;
import php.Web;
/**
 * ...
 * @author GINER Jérémy
 */
class Server {

	static function main(){
	
		// Model
			//var oModel = new Model();
	
		// View
			//var oView = new View( oModel );
        	
        // Controller
        	var oController = new Controller( Web.getParams() );//new Controller( oModel, oView );
			
    }
	
}