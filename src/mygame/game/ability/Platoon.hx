package mygame.game.ability;

import legion.ability.IAbility;
import mygame.game.entity.Unit;
import mygame.game.misc.weapon.EDamageType;
import space.Vector2i;
import space.Vector3;
import trigger.*;

import mygame.game.entity.SubUnit;

class Platoon extends UnitAbility {
	
	var _aSubUnit :Array<SubUnit>;
	var _oPlatoonGuidance :Guidance;
	
//______________________________________________________________________________
//	Constructor

	public function new( 
		oUnit :Unit
	) {
		super( oUnit );
		
		
		// create children
		_aSubUnit = new Array<SubUnit>();
		for ( i in 0...9 ) {
			var oSubPosition = _oUnit.ability_get(Position).clone();
			switch( i ) {
				case 0 : oSubPosition.add( 0, 0 );
				case 1 : oSubPosition.add( -4000, 0 );
				case 2 : oSubPosition.add( 4000, 0 );
				case 3 : oSubPosition.add( 4000, 4000 );
				case 4 : oSubPosition.add( -4000, -4000 );
				case 5 : oSubPosition.add( 4000, -4000 );
				case 6 : oSubPosition.add( -4000, 4000 );
				case 7 : oSubPosition.add( 0, 4000 );
				case 8 : oSubPosition.add( 0, -4000 );
			}
			_aSubUnit.push( new SubUnit( oUnit, oSubPosition ) );
		}
		
		_oPlatoonGuidance = _oUnit.ability_get( Guidance );
		if ( _oPlatoonGuidance == null )
			trace( '[ERROR] unit with platoon ability require GuidancePlatoon' );
		
	}

//______________________________________________________________________________
//	Accessor
/*
	public function subUnitPostion_get( ) {
		
		
		
		return null;
	}
	*/
	public function subUnit_get() {
		// refresh
		// TODO : on dispose?
		var a = _aSubUnit.copy();
		for ( o in a )
			if ( o.dispose_check() )
				_aSubUnit.remove( o );
		
		return _aSubUnit;
	}
	
	public function offset_get( iKey :Int ) {
		var iPitch = 3 % _aSubUnit.length;
		
		return new Vector2i( 
			iKey % iPitch, 
			Math.floor( iKey / iPitch ) 
		);
	}
	
//______________________________________________________________________________
//	Modifier
	
	
//______________________________________________________________________________
//	Shortcut

	
//______________________________________________________________________________
//	


}