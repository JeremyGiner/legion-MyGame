package mygame.game.ability;
import mygame.game.entity.Unit;
import mygame.game.query.UnitDist;

/**
 * Personnal shield emmiter
 * @author GINER Jérémy
 */
class DivineShield extends UnitAbility {

	var _oSource :SpawnShield;
	
//______________________________________________________________________________
//	Constructor
	
	public function new( oUnit :Unit, oSource :SpawnShield ) {
		_oSource = oSource;
		super( oUnit );
	}

//______________________________________________________________________________
//	Accessor

	public function source_get() {
		return _oSource;
	}
	
	public function expired_check() {
		//TODO check if source is disposed
		
		// Get ditance beween source and target
		var fDistance = _oUnit.mygame_get().singleton_get(UnitDist).data_get([ _oUnit, _oSource.unit_get() ]);
		
		return fDistance > _oSource.radius_get();
	}
}