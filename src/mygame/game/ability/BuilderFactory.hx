package mygame.game.ability;

import mygame.game.entity.*;
import mygame.game.misc.offer.*;
import space.Vector2i;

import mygame.game.ability.Position;
import mygame.game.ability.Guidance;

import space.Vector2i in Vector2;

/**
 * Allow an entity to create a new unit near it for a price.
 * 
 * @author GINER Jérémy
 */
class BuilderFactory extends Builder {

	var _oPosition :Vector2;
	var _oRallyPoint :Vector2;
	//var _oProduct :Array<Unit>;
	//var _oCost :Array<Int>;
	static var _aOffer :Array<Offer> = 
		[
			new Offer( 15, 'Build a Solier 2' ),
			new Offer( 15, 'Build a Tank' ),
		];
	
//______________________________________________________________________________
//	Constructor

	public function new( oUnit :Unit ) {
		super( oUnit );
		
		// Set spawn point
		var oPosition = _oUnit.ability_get( Position );
		if( oPosition == null ) throw('[ERROR]:buy:seller must have Position ability.'); 
		_oPosition = oPosition.clone();
		
		_oRallyPoint = _oPosition.clone();
		_oRallyPoint.y -= 4999;
	}

//______________________________________________________________________________
//	Accessor
	
	public function offerArray_get() { return _aOffer; } 
	
	public function buy( iOfferIndex :Int ) {
	
		// Check offer index validity
		if( iOfferIndex < 0 || iOfferIndex >= _aOffer.length ) 
			throw('[ERROR]:'+iOfferIndex+' is an invalide offer index.');
			
		// Check owner
		if( _oUnit.owner_get() == null )
			throw('[ERROR]:neutral unit can not sell.');
			
		//TODO : 
		// check cost and credit
		// check spawn point occupation
			
		//_aOffer[iOfferIndex].accept( cast _oUnit.owner_get(), _oUnit );
		_oUnit.owner_get().credit_add( -_aOffer[ iOfferIndex ].cost_get() );
		var oProduct = unit_create( iOfferIndex );
		
		var oGuidance = oProduct.ability_get( Guidance );
		if ( oGuidance == null ) throw('[ERROR]:buy:product must have Guidance ability.');
		oGuidance.goal_set( _oRallyPoint );
		
	}
	
	// TEST 
	function unit_create( i :Int ) :Unit {
		switch( i ) {
			case 99 : 
				var u = new Soldier( 
						cast _oUnit.game_get(), 
						_oUnit.owner_get(), 
						_oPosition 
					);
				_oUnit.game_get().entity_add(
					u
				);
				return u;
			case 98 : 
				var u = new Bazoo( 
						cast _oUnit.game_get(), 
						_oUnit.owner_get(), 
						_oPosition 
					);
				_oUnit.game_get().entity_add(
					u
				);
				return u;
			case 1 : 
				var u = new Tank( 
						cast _oUnit.game_get(), 
						_oUnit.owner_get(), 
						_oPosition 
					);
				_oUnit.game_get().entity_add(
					u
				);
				return u;
			case 0 : 
				var u = new PlatoonUnit( 
						cast _oUnit.game_get(), 
						_oUnit.owner_get(), 
						_oPosition 
					);
				_oUnit.game_get().entity_add(
					u
				);
				return u;
			
			default: throw('wooops');
		}
		return null;
	}

}