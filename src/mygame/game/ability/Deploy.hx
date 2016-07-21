package mygame.game.ability;
import legion.entity.Entity;
import legion.IBehaviour;
import space.Vector2i;
import utils.Macro;

/**
 * ...
 * @author GINER Jérémy
 */
class Deploy extends EntityAbility implements IBehaviour {

	/**
	 * Last known position 
	 * used to verify movement
	 */
	var _oPosition :Vector2i;
	
	/**
	 * Percent of completion of deploy
	 * [0.0;0.1]
	 */
	var _fDeployed :Float;
	
//_____________________________________________________________________________
//	Contructor
	
	public function new( oEntity :Entity ) {
		super( oEntity );
		
		var oPos = _oEntity.ability_get(Position);
		_oPosition = new Vector2i(oPos.x,oPos.y);
	}
	
//_____________________________________________________________________________
//	Accessor

	public function percent_get() {
		return _fDeployed;
	}
	
	public function processName_get() {
		return 'deploy';
	}
	
	
//_____________________________________________________________________________
//	Process
	
	public function process() {
		var oPos = _oEntity.ability_get(Position);
		
		// Case : didn't move
		if ( _oPosition.x == oPos.x && _oPosition.y == oPos.y ) {
			_fDeployed =  Math.min( _fDeployed + 0.01, 1.0);
		}
		//Case : moved
		else {
			_fDeployed = 0;
			_oPosition = new Vector2i(oPos.x,oPos.y);
		}
		
		if ( _fDeployed != 1 ) {
			var oWeapon = _oEntity.ability_get(Weapon);
			oWeapon.cooldown_get().reset();
		}
	}
	
}