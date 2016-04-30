package logicweaver_gigablaster;

import haxe.ds.StringMap;
import haxe.Unserializer;
import logicweaver_gigablaster.GigaEvolutionProcessor;
import sys.io.File;

/**
 * Spirit trainer
 * 
 * @author GINER Jérémy
 */
class Main {

	static function main() {
	
		// Current directory ( should be symfony/web/ )
		untyped __call__('echo', untyped __call__('getcwd') );
		untyped __call__('echo', '\r\n' );
		
		// PHP Symfony Bootstrap
		untyped __call__('require_once', '/../app/bootstrap.php.cache');
		
		// Process
		var oProcessor = null;
		
		// Load attempt
		var s = null;
		try {
			trace( 'try to load save point');
			s = File.getContent('gen');
			
		} catch ( e :String ) {
			trace( 'attempt failed : '+e);
		}
		
		// Get processor
		if ( s != null) {
			trace( 'Save point loaded');
			var oUnserialiser = new Unserializer(s);
			oProcessor = oUnserialiser.unserialize();
			GigaEvolutionProcessor._aScoreCache = new StringMap<Array<Int>>();
		} else 
			oProcessor = new GigaEvolutionProcessor();
		
		while ( true ) {
			oProcessor.process();
		}
    }
}