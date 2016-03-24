package mygame.server;

import mygame.server.controller.Controller;
import mygame.server.model.Model;

class MyServer {
	static function main(){
		
		// Model
        var oModel = new Model();
		
		// View
		//var displayer = new MyDisplayer( game, GUI );
        	
        // Controller
        var oController = new Controller( oModel );
			
    }
}