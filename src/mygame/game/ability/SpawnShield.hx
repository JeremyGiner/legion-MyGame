package mygame.game.ability;
import legion.entity.Entity;
import mygame.game.entity.Unit;

/**
 * Personnal shield emmiter
 * @author GINER Jérémy
 */
class SpawnShield extends UnitAbility {

	var _oPosition :Position;

	var _iRadius :Int;	// 10000 = tile size

//______________________________________________________________________________
//	Constructor
	
	public function new( oUnit :Unit, iRadius :Int = 20000 ) {
		super( oUnit );
		
		// Position
		_oPosition = oUnit.ability_get( Position );
		if ( _oPosition == null ) trace('[ERROR]:ability dependency not respected.');
		
		// Radius
		_iRadius = iRadius;
		if ( _iRadius < 0 ) throw 'invalid radius.';
	}

//______________________________________________________________________________
//	Accessor

	public function radius_get() :Int { return _iRadius; };
	
	public function effect_apply( oEntity :Entity ) {
		// Skip target already under the effect
		if( oEntity.ability_get(DivineShield) != null )
			return;
		
		oEntity.ability_add(new DivineShield(cast oEntity,this));
	}
}