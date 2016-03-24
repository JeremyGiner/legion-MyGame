package mygame.game.misc.offer;

import mygame.game.entity.Unit;
import legion.ability.IAbility;
import mygame.game.entity.Player;
import legion.entity.Entity;
import mygame.game.ability.Position;
import mygame.game.ability.Guidance;

import mygame.game.entity.Bazoo;

class OfferUnit extends Offer {
	
//______________________________________________________________________________
//	Constructor

	function new( iCost :Int, sName :String ) {
 		super( iCost, sName );
	}

//______________________________________________________________________________
//	Accessor
	
	override public function accept( oBuyer :Player, oSeller :Entity ) :Void { 
		super.accept( oBuyer, oSeller );
		
		var oPosition = oSeller.ability_get( Position );
		if( oPosition == null ) throw('[ERROR]:buy:seller must have Position ability.'); 
		var oUnit = unit_create( oBuyer, oSeller );
		oSeller.game_get().entity_add( oUnit );
		
		// Order unit to get out of the factory
		/*var oGuidance = oUnit.ability_get( Guidance );
		if( oGuidance == null ) throw('[ERROR]:buy:product must have Guidance ability.');
		oGuidance.goal_set( new Vector3( oPosition.x,oPosition.y+0.4 ) );*/
	}
	
//______________________________________________________________________________
//	Sub-function

	function unit_create( oBuyer :Player, oSeller :Entity  ) :Unit {
		throw('[ERROR]:abstract function');
		return null;
		//Example : new Bazoo( oSeller.game_get(), oBuyer, oPosition.x, oPosition.y );
	}

}