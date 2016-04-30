package mygame.client.view;

import js.html.DivElement;
import mygame.game.GameConf;

import mygame.client.model.Model;

/**
 * @author GINER Jérémy
 */
class BlockGameConf {
	
	var _oDiv :DivElement;
	var _oConf :GameConf;

//______________________________________________________________________________
//	Constructor

	public function new( oConf :GameConf, oDiv :DivElement ) {
		_oConf = oConf;
		_oDiv = oDiv;
		
		update();
	}
	
//______________________________________________________________________________
//	Updater
	
	public function update() {
		
		// Cleaning
		_oDiv.innerHTML = '';
		
		// Print
		_oDiv.innerHTML = _render();
		
	}

//______________________________________________________________________________
//	Sub-routine
	
	function _render() :String {
		
		// Hide if not paused
		
		var s = '<h1>Conf</h1><div>';
		
		//TODO
		s += '</div>';
		
		return s;
	}
	
}