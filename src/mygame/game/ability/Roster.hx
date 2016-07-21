package mygame.game.ability;

import legion.ability.Ability;
import legion.entity.Entity;
import mygame.game.ability.Position;
import mygame.game.MyGame;
import mygame.game.entity.Player;

/**
 * 
 * @author GINER Jérémy
 */
class Roster extends Ability {

	var _aUnitType :Array<String>;
	var _aUnitActive :Array<Entity>;
	
	var _oFactory :Entity;
	
//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame, aUnitType :Array<String> ) {
		super();
		_oFactory = null;
		_aUnitActive = new Array<Entity>();
		
		_aUnitType = aUnitType;
	}

//______________________________________________________________________________
//	Accessor
	
	public function unitType_get( iIndex :Int ) {
		return _aUnitType[iIndex];
	}

	public function unitType_get_all() {
		return _aUnitType;// TODO : clone?
	}
	public function activeUnit_get( iIndex :Int ) {
		return _aUnitActive[ iIndex ]; 
	}
	public function activeUnit_get_all() {
		return _aUnitActive;// TODO : clone?
	}
	
	public function factory_get() {
		return _oFactory;
	}
//______________________________________________________________________________
//	Modifier
	public function factory_set( oEntity :Entity ) {
		_oFactory = oEntity;
	}
	
//______________________________________________________________________________
//	Process

	public function build( iIndex :Int ) {
		// TODO : remove credit
		_oFactory.ability_get(Loyalty).owner_get().credit_add( -price_get( _aUnitType[iIndex] ) );
		
		// Create unit
		var oProduct :Entity = Type.createInstance( 
			Type.resolveClass( _aUnitType[iIndex] ), 
			[
				_oFactory.game_get(),
				_oFactory.ability_get(Loyalty).owner_get(),
				_oFactory.ability_get(Position)
			] 
		);
		_oFactory.game_get().entity_add( oProduct );
		
		// Index unit
		_aUnitActive[ iIndex ] = oProduct;
		
		// Go to rally point
		var _oRallyPoint = _oFactory.ability_get(Position).clone();
		_oRallyPoint.y -= 4999;
		
		oProduct.ability_get(Guidance).waypoint_set( _oRallyPoint );
	}
	
//______________________________________________________________________________
//	Sub-routine
//______________________________________________________________________________
//	Utils

	static public function price_get( sUnitType :String ) {
		switch( sUnitType ) {
			case 'mygame.game.entity.Soldier' : return 10;
			case 'mygame.game.entity.Bazoo' : return 20;
		}
		return 11;
	}

}