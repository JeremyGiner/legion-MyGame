package mygame.client;

import js.Browser;
import mygame.client.model.Model;
import mygame.client.view.View;
import mygame.client.controller.Controller;

class MyClient {

	static function main(){
	
		// Model
        	var oModel = new Model();
	
		// View
			var oView = new View( oModel );
        	
        // Controller
        	var oController = new Controller( oModel, oView );
		
		untyped Browser.window.haxe= { controller: oController };
		
    }
}