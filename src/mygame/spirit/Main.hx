package mygame.spirit;

/**
 * Spirit trainer
 * 
 * @author GINER Jérémy
 */
class Main {

	static function main(){
	
		// Model
        	//var oModel = new Model();
	
		// View
			//var oView = new View( oModel );
        	
        // Controller
        	//var oController = new Controller( oModel, oView );
			
		var oProcessor = new MyEvolutionProcessor();
		
		
		while ( true ) {
			oProcessor.process();
		}
    }
}