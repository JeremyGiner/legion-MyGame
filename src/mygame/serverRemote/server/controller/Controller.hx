package mygame.serverRemote.server.controller;
import sys.io.FileOutput;
import sys.io.Process;
import sys.io.File;
/**
 * ...
 * @author GINER Jérémy
 */
class Controller {
	var _oProcess :Process;
	public function new( mParam :Map<String,String> ) {
		if ( mParam.exists('start') ) {
			start();
			php.Lib.print('Started');
			Sys.exit( 0 );
		} else {
			if ( mParam.exists('log') ) {
				php.Lib.print( log_get() );
				Sys.exit( 0 );
			}
		}
	}
	
	public function start() {
		var _oProcess = new Process(
			'D:\\wamp\\bin\\php\\php5.4.12\\php.exe > C:\\mygame.log ', 
			[
				'D:\\Workspace\\HaxeTest\\out\\server\\MyServer\\server.php', 
			]
		);
		//var _oProcess = new Process('echo lol', [] );
		
	}
	
	public function log_get() {
		
		//TODO: make something better
		var fin = File.read( 'C:\\mygame.log', false );
		var s = '';
		try {
			s += "file content:";
			var lineNum = 0;
			while( true ) {
				var str = fin.readLine();
				//s += "line " + (++lineNum) + ": " + str + "<br>";
				s += str + "<br>";
			}
		} catch ( ex:haxe.io.Eof ) { }
		fin.close();
		return s;
	}
}